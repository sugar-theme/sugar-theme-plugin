#!/usr/bin/env node
// Check the schema of a section or block you created or added settings to.
//
//   node schema-check.js FILE.liquid [FILE.liquid ...]
//
// Fails (exit 1) on what makes the editor hard to use or the upload break:
//   - a header group holding more than six settings (a wall the user has to scroll)
//   - a header whose settings are all hidden by the same condition but which is
//     shown itself, so the editor prints a heading with nothing under it
//   - a visible_if using >, <, >=, <= or parentheses, or longer than 250 characters
//   - a range with more than 101 steps
//   - a "category" at the top level of the schema instead of inside a preset

const fs = require("fs");

const CAP = 6;
const NOT_SETTINGS = new Set(["header", "paragraph"]);

function schemaOf(file) {
  const src = fs.readFileSync(file, "utf8");
  const m = src.match(/{%-?\s*schema\s*-?%}([\s\S]*?){%-?\s*endschema\s*-?%}/);
  if (!m) return null;
  return JSON.parse(m[1]);
}

function clauses(cond) {
  const expr = cond.trim().replace(/^\{\{\s*|\s*\}\}$/g, "");
  return / or /.test(expr) ? [expr] : expr.split(" and ").map((c) => c.trim());
}

// The "and" clauses every setting in the group shares, or null if any is always shown.
function sharedCondition(items) {
  let common = null;
  for (const s of items) {
    if (!s.visible_if) return null;
    const c = clauses(s.visible_if);
    common = common === null ? c : common.filter((k) => c.includes(k));
  }
  return common && common.length ? common : null;
}

function groups(settings) {
  const out = [];
  let header = null;
  let items = [];
  for (const s of settings || []) {
    if (s.type === "header") {
      if (header || items.length) out.push([header, items]);
      header = s;
      items = [];
    } else if (!NOT_SETTINGS.has(s.type)) {
      items.push(s);
    }
  }
  if (header || items.length) out.push([header, items]);
  return out;
}

function check(file) {
  const problems = [];
  let schema;
  try {
    schema = schemaOf(file);
  } catch (e) {
    return [`schema is not valid JSON: ${e.message}`];
  }
  if (!schema) return [];

  if ("category" in schema) problems.push('"category" belongs inside a preset, not at the top level');

  const scopes = [["settings", schema.settings]];
  for (const b of schema.blocks || []) if (b.settings) scopes.push([`blocks[${b.type}]`, b.settings]);

  for (const [scope, settings] of scopes) {
    for (const [header, items] of groups(settings)) {
      const label = header ? `"${header.content}"` : "(before the first header)";
      if (items.length > CAP) {
        problems.push(
          `${scope} ${label} holds ${items.length} settings (max ${CAP}): split it by what the user is doing`
        );
      }
      const shared = header && items.length && !header.visible_if && sharedCondition(items);
      if (shared) {
        problems.push(
          `${scope} ${label} shows with nothing under it unless it carries "visible_if": "{{ ${shared.join(" and ")} }}"`
        );
      }
    }
    for (const s of settings || []) {
      const v = s.visible_if;
      if (v) {
        const expr = v.replace(/^\{\{|\}\}$/g, "");
        if (/[<>]/.test(expr)) problems.push(`${scope} "${s.id}" visible_if uses > or < (not supported)`);
        if (/[()]/.test(expr)) problems.push(`${scope} "${s.id}" visible_if uses parentheses (not supported)`);
        if (v.length > 250) problems.push(`${scope} "${s.id}" visible_if is ${v.length} characters (max 250)`);
      }
      if (s.type === "range" && s.step && (s.max - s.min) / s.step > 101) {
        problems.push(`${scope} "${s.id}" range has ${(s.max - s.min) / s.step} steps (max 101)`);
      }
    }
  }
  return problems;
}

const files = process.argv.slice(2);
if (!files.length) {
  console.error("Usage: node schema-check.js FILE.liquid [FILE.liquid ...]");
  process.exit(2);
}
let failed = 0;
for (const f of files) {
  const problems = check(f);
  if (problems.length) {
    failed++;
    for (const p of problems) console.log(`${f}: ${p}`);
  } else {
    console.log(`${f}: OK`);
  }
}
process.exit(failed ? 1 : 0);
