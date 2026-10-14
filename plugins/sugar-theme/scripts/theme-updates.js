#!/usr/bin/env node
// Theme updates for a pulled Sugar theme, driven by the update-check skill.
//
//   node theme-updates.js check THEME_DIR --check-url URL --files-url URL [--base BUILD]
//   node theme-updates.js apply THEME_DIR
//
// check  Fingerprints every code file in THEME_DIR (never sends the files), asks the Sugar Theme
//        MCP's check_url for the plan and writes it to WORK/plan.json. For every file both the
//        merchant and Sugar changed, downloads the original it started from (WORK/base/) and the
//        latest (WORK/latest/), and pre-merges it into WORK/merged/: Liquid, JS and CSS with
//        `git merge-file` (conflicts marked), JSON key by key. WORK/merge-report.json lists what
//        merged cleanly and what conflicts. Nothing in THEME_DIR changes. --base names the build the
//        changed files started from, when the user's app prompt gives one: after the app's zip
//        update the untouched files match the latest, so the build can't be read from them.
// apply  Writes the latest copy of every untouched file the plan replaces, every protected file
//        and every new file into THEME_DIR, and lists them in WORK/changed.txt for
//        `shopify theme push --only`. Merged files are the agent's job: copy each from
//        WORK/merged/ once reviewed, and add it to the push.
//
// WORK is THEME_DIR + ".sugar-update", beside the theme so a theme push never picks it up.
// The fingerprint rules match the app's shared/theme-update.ts and the theme's release_lib.py.

const fs = require("fs");
const path = require("path");
const crypto = require("crypto");
const { spawnSync } = require("child_process");

const fail = (msg) => {
  console.error(msg);
  process.exit(1);
};

const [cmd, themeArg, ...rest] = process.argv.slice(2);
if (!["check", "apply"].includes(cmd) || !themeArg) fail("usage: node theme-updates.js check THEME_DIR --check-url URL --files-url URL [--base BUILD]\n       node theme-updates.js apply THEME_DIR");
const themeDir = path.resolve(themeArg);
if (!fs.existsSync(path.join(themeDir, "config", "settings_schema.json"))) fail(`${themeDir} is not a pulled theme (no config/settings_schema.json).`);
const work = themeDir.replace(/[\\/]+$/, "") + ".sugar-update";
const flag = (name) => {
  const i = rest.indexOf(name);
  return i === -1 ? null : rest[i + 1];
};

/* ── Fingerprints ───────────────────────────────────────────────────── */

const CODE_DIRS = new Set(["assets", "blocks", "sections", "snippets", "layout", "locales"]);
const BINARY = new Set([".png", ".webp", ".jpg", ".jpeg", ".gif", ".woff", ".woff2", ".ttf", ".otf", ".ico"]);

function isCodeFile(p) {
  if (p === "config/settings_schema.json") return true;
  const top = p.split("/", 1)[0];
  if (!CODE_DIRS.has(top)) return false;
  return !(top === "sections" && p.endsWith(".json"));
}

const isSpace = (b) => b === 0x20 || b === 0x09 || b === 0x0a || b === 0x0d || b === 0x0b || b === 0x0c;

function normalizeText(buf) {
  const lines = [];
  let start = 0;
  const push = (end) => {
    let e = end;
    while (e > start && isSpace(buf[e - 1])) e--;
    lines.push(buf.subarray(start, e));
  };
  for (let i = 0; i < buf.length; i++) {
    const b = buf[i];
    if (b === 0x0a || b === 0x0d) {
      push(i);
      if (b === 0x0d && buf[i + 1] === 0x0a) i++;
      start = i + 1;
    }
  }
  push(buf.length);
  while (lines.length && lines[lines.length - 1].length === 0) lines.pop();
  if (!lines.length) return Buffer.from("\n");
  return Buffer.concat(lines.flatMap((l) => [l, Buffer.from("\n")]));
}

const sortKeys = (v) => {
  if (Array.isArray(v)) return v.map(sortKeys);
  if (v && typeof v === "object") return Object.fromEntries(Object.keys(v).sort().map((k) => [k, sortKeys(v[k])]));
  return v;
};

function parseJson(buf) {
  try {
    const text = new TextDecoder("utf-8", { fatal: true }).decode(buf).replace(/^﻿/, "").replace(/^\s*\/\*[\s\S]*?\*\/\s*/, "");
    return { ok: true, value: JSON.parse(text) };
  } catch {
    return { ok: false };
  }
}

function fingerprint(p, buf) {
  const ext = path.extname(p).toLowerCase();
  let payload;
  if (BINARY.has(ext)) payload = buf;
  else if (ext === ".json") {
    const parsed = parseJson(buf);
    payload = parsed.ok ? Buffer.from(JSON.stringify(sortKeys(parsed.value))) : normalizeText(buf);
  } else payload = normalizeText(buf);
  return crypto.createHash("sha256").update(payload).digest("hex");
}

function walk(dir, prefix = "") {
  const out = [];
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    const rel = prefix ? `${prefix}/${e.name}` : e.name;
    if (e.isDirectory()) out.push(...walk(path.join(dir, e.name), rel));
    else if (e.isFile()) out.push(rel);
  }
  return out;
}

/* ── Network ────────────────────────────────────────────────────────── */

async function post(url, body) {
  const res = await fetch(url, { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(body) });
  const data = await res.json().catch(() => ({}));
  if (!res.ok) fail(data.error || `${url.split("?")[0]} answered ${res.status}`);
  return data;
}

async function fetchFiles(filesUrl, wanted) {
  const got = [];
  for (let i = 0; i < wanted.length; i += 300) got.push(...(await post(filesUrl, { files: wanted.slice(i, i + 300) })).files);
  return got;
}

const write = (file, buf) => {
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(file, buf);
};

/* ── JSON three-way merge (locales, settings_schema) ────────────────── */

const same = (a, b) => JSON.stringify(sortKeys(a)) === JSON.stringify(sortKeys(b));
const isObj = (v) => v && typeof v === "object" && !Array.isArray(v);

function mergeJson(base, theirs, latest, at, conflicts) {
  if (same(theirs, base)) return latest;
  if (same(latest, base) || same(latest, theirs)) return theirs;
  if (isObj(base) && isObj(theirs) && isObj(latest)) {
    const out = {};
    const keys = [...Object.keys(latest), ...Object.keys(theirs).filter((k) => !(k in latest))];
    for (const k of keys) {
      const b = base[k], t = theirs[k], l = latest[k];
      if (t === undefined && b !== undefined && same(l, b)) continue; // they removed it, Sugar didn't touch it
      if (l === undefined && b !== undefined && same(t, b)) continue; // Sugar removed it, they didn't touch it
      if (t === undefined) { if (l !== undefined) out[k] = l; continue; }
      if (l === undefined) { out[k] = t; continue; }
      out[k] = b === undefined ? (same(t, l) ? l : (conflicts.push(`${at}${k}`), t)) : mergeJson(b, t, l, `${at}${k}.`, conflicts);
    }
    return out;
  }
  conflicts.push(at.replace(/\.$/, "") || "(whole file)");
  return theirs;
}

/* ── Commands ───────────────────────────────────────────────────────── */

async function check() {
  const checkUrl = flag("--check-url");
  const filesUrl = flag("--files-url");
  if (!checkUrl || !filesUrl) fail("check needs --check-url and --files-url (both from the MCP's check_theme_updates).");
  const files = walk(themeDir).filter(isCodeFile).map((p) => ({ path: p, sha256: fingerprint(p, fs.readFileSync(path.join(themeDir, p))) }));
  const plan = await post(checkUrl, { files, base: flag("--base") || undefined });
  fs.rmSync(work, { recursive: true, force: true });
  write(path.join(work, "plan.json"), JSON.stringify({ ...plan, files_url: filesUrl }, null, 2));

  const report = { clean: [], conflicts: [], manual: [] };
  const toMerge = plan.merge.filter((m) => m.base);
  if (toMerge.length) {
    const got = await fetchFiles(filesUrl, toMerge.flatMap((m) => [{ build: m.base, path: m.path }, { build: "latest", path: m.path }]));
    for (const f of got) if (f.base64) write(path.join(work, f.build === "latest" ? "latest" : "base", f.path), Buffer.from(f.base64, "base64"));
    const hasGit = spawnSync("git", ["--version"]).status === 0;
    for (const m of toMerge) {
      const base = path.join(work, "base", m.path), latest = path.join(work, "latest", m.path), theirs = path.join(themeDir, m.path);
      const out = path.join(work, "merged", m.path);
      if (!fs.existsSync(base) || !fs.existsSync(latest)) { report.manual.push({ path: m.path, why: "original or latest missing" }); continue; }
      if (m.path.endsWith(".json")) {
        const [b, t, l] = [base, theirs, latest].map((f) => parseJson(fs.readFileSync(f)));
        if (!b.ok || !t.ok || !l.ok) { report.manual.push({ path: m.path, why: "a copy is not valid JSON" }); continue; }
        const conflicts = [];
        write(out, JSON.stringify(mergeJson(b.value, t.value, l.value, "", conflicts), null, 2) + "\n");
        (conflicts.length ? report.conflicts : report.clean).push(conflicts.length ? { path: m.path, keys: conflicts } : m.path);
        continue;
      }
      if (!hasGit) { report.manual.push({ path: m.path, why: "git is not installed, merge by hand" }); continue; }
      const r = spawnSync("git", ["merge-file", "-p", "-L", "yours", "-L", "original", "-L", "sugar", theirs, base, latest], { maxBuffer: 64 * 1024 * 1024 });
      if (r.status < 0 || r.status === null || r.status > 127) { report.manual.push({ path: m.path, why: "git merge-file failed" }); continue; }
      write(out, r.stdout);
      (r.status === 0 ? report.clean : report.conflicts).push(r.status === 0 ? m.path : { path: m.path, conflicts: r.status });
    }
  }
  for (const m of plan.merge.filter((x) => !x.base)) report.manual.push({ path: m.path, why: "no original found: compare with the latest by hand" });
  write(path.join(work, "merge-report.json"), JSON.stringify(report, null, 2));

  const n = (a) => a.length;
  console.log(`Sugar ${plan.latest.version} (build ${plan.latest.commit}); this theme came from ${plan.base ? `build ${plan.base.commit}` : "an unknown build"}.`);
  console.log(`up to date ${plan.upToDate} · replace ${n(plan.replace)} · add ${n(plan.add)} · protected replaced ${n(plan.protectedReplaced)} · merge ${n(plan.merge)} (clean ${n(report.clean)}, conflicts ${n(report.conflicts)}, by hand ${n(report.manual)}) · changed but nothing to do ${n(plan.keep)} · their own ${n(plan.own)} · retired ${n(plan.retired)}`);
  console.log(`${n(plan.changes)} change(s) since this theme's build. Plan: ${path.join(work, "plan.json")}`);
}

async function apply() {
  const planFile = path.join(work, "plan.json");
  if (!fs.existsSync(planFile)) fail("Run check first.");
  const plan = JSON.parse(fs.readFileSync(planFile, "utf8"));
  const paths = [...plan.replace, ...plan.protectedReplaced, ...plan.add];
  if (!paths.length) return console.log("Nothing to replace or add.");
  const got = await fetchFiles(plan.files_url, paths.map((p) => ({ build: "latest", path: p })));
  const missing = got.filter((f) => !f.base64).map((f) => f.path);
  if (missing.length) fail(`The latest build is missing ${missing.join(", ")}. Nothing was written; try again later.`);
  for (const f of got) write(path.join(themeDir, f.path), Buffer.from(f.base64, "base64"));
  write(path.join(work, "changed.txt"), paths.join("\n") + "\n");
  console.log(`Wrote ${paths.length} file(s) into ${themeDir}. List for the push: ${path.join(work, "changed.txt")}`);
}

(cmd === "check" ? check() : apply()).catch((e) => fail(e && e.message ? e.message : String(e)));
