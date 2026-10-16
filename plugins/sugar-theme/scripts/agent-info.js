#!/usr/bin/env node
// Print which model, thinking level and client this agent runs as, for the feedback skill's
// report_issue and share_session calls.
//
//   node agent-info.js   →   {"model":"claude-sonnet-5-5","effort":"high","agent":"Claude Code 2.1.299, desktop"}
//
// An agent can't reliably name its own thinking level, and often not its exact model, so this
// reads them from the client instead: Claude Code passes the session's effort to every command
// (CLAUDE_EFFORT) and records the model on every reply in the conversation file it keeps under
// ~/.claude/projects/. Anything it can't find prints as null; the agent fills the model from its
// own instructions and sends effort "unknown".

const fs = require("fs");
const os = require("os");
const path = require("path");

const env = process.env;
const out = { model: null, effort: env.CLAUDE_EFFORT || null, agent: null };

/* ── The model (and effort, if the variable is missing) from this conversation's file ── */

const sessionId = env.CLAUDE_CODE_SESSION_ID;
const root = path.join(env.CLAUDE_CONFIG_DIR || path.join(os.homedir(), ".claude"), "projects");
let version = null;
let entrypoint = env.CLAUDE_CODE_ENTRYPOINT || null;
if (sessionId && /^[A-Za-z0-9-]+$/.test(sessionId) && fs.existsSync(root)) {
  let file = null;
  for (const dir of fs.readdirSync(root)) {
    const p = path.join(root, dir, `${sessionId}.jsonl`);
    if (fs.existsSync(p)) {
      file = p;
      break;
    }
  }
  if (file) {
    // Only the tail: the latest reply is what counts, and the file can be tens of MB.
    const size = fs.statSync(file).size;
    const len = Math.min(size, 4 * 1024 * 1024);
    const buf = Buffer.alloc(len);
    const fd = fs.openSync(file, "r");
    fs.readSync(fd, buf, 0, len, size - len);
    fs.closeSync(fd);
    const lines = buf.toString("utf8").split("\n");
    for (let i = lines.length - 1; i >= 0; i--) {
      if (!lines[i].includes('"assistant"')) continue;
      let d;
      try {
        d = JSON.parse(lines[i]);
      } catch {
        continue;
      }
      const model = d.message && d.message.model;
      if (d.type !== "assistant" || !model || model.startsWith("<")) continue;
      out.model = model;
      if (!out.effort && typeof d.effort === "string") out.effort = d.effort;
      version = d.version || null;
      entrypoint = entrypoint || d.entrypoint || null;
      break;
    }
  }
}

/* ── The client ─────────────────────────────────────────────────────── */

const where = { cli: "terminal", "claude-desktop": "desktop", "claude-vscode": "VS Code", "claude-jetbrains": "JetBrains", "sdk-ts": "SDK", "sdk-py": "SDK" };
const cc = (env.AI_AGENT || "").match(/^claude-code_(\d+)-(\d+)-(\d+)/);
if (cc || env.CLAUDECODE) {
  const v = cc ? `${cc[1]}.${cc[2]}.${cc[3]}` : version;
  out.agent = ["Claude Code" + (v ? ` ${v}` : ""), entrypoint ? where[entrypoint] || entrypoint : null].filter(Boolean).join(", ");
} else if (env.AI_AGENT) {
  out.agent = env.AI_AGENT;
}

console.log(JSON.stringify(out));
