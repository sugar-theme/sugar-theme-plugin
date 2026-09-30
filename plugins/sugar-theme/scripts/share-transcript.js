#!/usr/bin/env node
// Upload this task's conversation to the Sugar Theme MCP, for users whose AGENTS.md says
// `Sharing: sessions`.
//
//   node share-transcript.js UPLOAD_URL            upload (UPLOAD_URL comes from share_session)
//   node share-transcript.js UPLOAD_URL --dry-run  print what would be sent, send nothing
//
// The agent never retypes the conversation. Claude Code already saves every conversation as a
// JSON Lines file under ~/.claude/projects/; this finds the one that contains UPLOAD_URL (the
// share_session result just landed in it), keeps the part since the previous share, trims it to
// the dialogue, a one-line trace of each step and any errors, strips secrets and uploads it once.

const fs = require("fs");
const os = require("os");
const path = require("path");

const [uploadUrl, flag] = process.argv.slice(2);
const dryRun = flag === "--dry-run";
const fail = (msg) => {
  console.error(msg);
  process.exit(1);
};
if (!uploadUrl || !/^https:\/\/\S+\/transcript\?t=[A-Za-z0-9_-]{32,64}$/.test(uploadUrl)) {
  fail("usage: node share-transcript.js UPLOAD_URL [--dry-run]  (the upload_url share_session returned)");
}
const token = new URL(uploadUrl).searchParams.get("t");

/* ── Find the conversation file ─────────────────────────────────────── */

const root = path.join(process.env.CLAUDE_CONFIG_DIR || path.join(os.homedir(), ".claude"), "projects");
const since = Date.now() - 2 * 24 * 60 * 60 * 1000;
const candidates = [];
for (const dir of fs.existsSync(root) ? fs.readdirSync(root) : []) {
  const full = path.join(root, dir);
  let entries = [];
  try {
    entries = fs.readdirSync(full);
  } catch {
    continue;
  }
  for (const f of entries) {
    if (!f.endsWith(".jsonl")) continue;
    const p = path.join(full, f);
    const st = fs.statSync(p);
    if (st.mtimeMs >= since) candidates.push({ p, mtime: st.mtimeMs });
  }
}
candidates.sort((a, b) => b.mtime - a.mtime);
const file = candidates.find((c) => fs.readFileSync(c.p, "utf8").includes(token));
if (!file) fail("Couldn't find this conversation's file (it is saved by Claude Code under ~/.claude/projects/). Nothing was sent.");

/* ── Keep this task: everything after the previous share ────────────── */

const lines = fs.readFileSync(file.p, "utf8").split("\n").filter(Boolean);
const tokenRe = /\/transcript\?t=([A-Za-z0-9_-]{32,64})/g;
let end = lines.length;
let start = 0;
for (let i = 0; i < lines.length; i++) {
  const found = [...lines[i].matchAll(tokenRe)].map((m) => m[1]);
  if (found.includes(token)) {
    end = i;
    break;
  }
  if (found.length) start = i + 1;
}

/* ── Plain text, trimmed ────────────────────────────────────────────── */
// What people said, word for word; every step the agent took as one short line; and any step
// that failed, with its error. The raw output of steps that worked (file contents, page data)
// stays on this computer: it is most of the bulk and almost none of the story.

const ERROR_MAX = 600;
const STEP_MAX = 110;
const textOf = (content) =>
  typeof content === "string"
    ? content
    : Array.isArray(content)
      ? content.map((b) => (b.type === "text" ? b.text : b.type === "image" ? "[image]" : "")).filter(Boolean).join("\n")
      : "";

// Claude's own system notes ride along inside messages; they are not the conversation.
const NOTES = /<(system-reminder|command-name|command-message|command-args|local-command-stdout|local-command-caveat)>[\s\S]*?<\/\1>/g;
const human = (t) => (t || "").replace(NOTES, "").trim();
const oneLine = (t, n) => {
  const s = String(t ?? "").split("\n").map((l) => l.trim()).find(Boolean) || "";
  return s.length > n ? `${s.slice(0, n)}…` : s;
};
const toolName = (name) => {
  const m = /^mcp__(?:plugin_[a-z0-9-]+_)?([a-z0-9-]+)__(.+)$/i.exec(name);
  return m ? `${m[1]} · ${m[2]}` : name;
};
const stepDetail = (input) => {
  if (!input || typeof input !== "object") return "";
  for (const k of ["description", "url", "file_path", "path", "query", "pattern", "command", "function", "code", "prompt"]) {
    if (typeof input[k] === "string" && input[k].trim()) return oneLine(input[k], STEP_MAX);
  }
  return oneLine(JSON.stringify(input), STEP_MAX);
};

const out = []; // { say: "USER"|"ASSISTANT", text } or { step: text }
for (const line of lines.slice(start, end)) {
  let d;
  try {
    d = JSON.parse(line);
  } catch {
    continue;
  }
  if (d.isSidechain || d.isMeta || !d.message) continue;
  const content = d.message.content;
  if (d.type === "user") {
    if (typeof content === "string") {
      if (human(content)) out.push({ say: "USER", text: human(content) });
      continue;
    }
    for (const b of content || []) {
      if (b.type === "text" && human(b.text)) out.push({ say: "USER", text: human(b.text) });
      if (b.type === "tool_result" && b.is_error) {
        const err = human(textOf(b.content));
        out.push({ step: `    ✗ ${err.length > ERROR_MAX ? `${err.slice(0, ERROR_MAX)}…` : err}`.replace(/\n/g, "\n      ") });
      }
    }
  } else if (d.type === "assistant") {
    for (const b of content || []) {
      if (b.type === "text" && b.text.trim()) out.push({ say: "ASSISTANT", text: b.text.trim() });
      if (b.type === "tool_use") {
        const detail = stepDetail(b.input);
        out.push({ step: `  · ${toolName(b.name)}${detail ? ` — ${detail}` : ""}` });
      }
    }
  }
}
let transcript = out
  .map((e, i) => (e.say ? `${i ? "\n" : ""}${e.say}:\n${e.text}\n` : e.step))
  .join("\n")
  .trim();

/* ── Redact ─────────────────────────────────────────────────────────── */

const project = process.env.CLAUDE_PROJECT_DIR || process.cwd();
try {
  const agents = fs.readFileSync(path.join(project, "AGENTS.md"), "utf8");
  const pw = (agents.match(/\*\*Storefront password:\*\*[ \t]*(.+)/) || [])[1];
  if (pw && pw.trim() && !pw.trim().startsWith("[")) transcript = transcript.split(pw.trim()).join("[storefront password]");
} catch {
  // no AGENTS.md: nothing project-specific to strip
}
const RULES = [
  [/\/transcript\?t=[A-Za-z0-9_-]{32,64}/g, "/transcript?t=[upload link]"],
  [/\bshp(?:at|ca|pa|ss)_[A-Za-z0-9]{20,}/g, "[shopify token]"],
  [/\bsk-[A-Za-z0-9_-]{20,}/g, "[api key]"],
  [/\beyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}/g, "[token]"],
  [/\b(Bearer|Basic)\s+[A-Za-z0-9._~+/=-]{16,}/g, "$1 [token]"],
  [/_shopify_essential=[^;\s"']+/g, "_shopify_essential=[cookie]"],
  [/((?:password|passwd|secret|api[_-]?key|access[_-]?token|client[_-]?secret)["']?\s*[:=]\s*["']?)[^\s"',}]{6,}/gi, "$1[redacted]"],
  [/[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}/g, "[email]"],
];
for (const [re, sub] of RULES) transcript = transcript.replace(re, sub);

if (!transcript.trim()) fail("Found the conversation but nothing to send since the last share. Nothing was sent.");

/* ── Send ───────────────────────────────────────────────────────────── */

if (dryRun) {
  process.stdout.write(transcript + "\n");
  console.error(`\n[dry run] ${transcript.length} characters from ${path.basename(file.p)}; nothing sent.`);
  process.exit(0);
}
fetch(uploadUrl, { method: "POST", headers: { "Content-Type": "text/plain; charset=utf-8" }, body: transcript })
  .then(async (r) => {
    const body = await r.text();
    if (!r.ok) fail(`Upload failed (${r.status}): ${body}`);
    console.log(`Shared the conversation: ${transcript.length} characters, redacted.`);
  })
  .catch((e) => fail(`Upload failed: ${e.message}`));
