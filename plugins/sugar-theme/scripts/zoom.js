#!/usr/bin/env node
// Look closer at a screenshot, or put two side by side.
//
//   node zoom.js crop  IMAGE X0 Y0 X1 Y1 [--scale 3] [--out OUT.png]
//   node zoom.js grid  IMAGE [--step 100] [--out OUT.png]
//   node zoom.js side  LEFT RIGHT [--out OUT.png]
//
// crop  cuts the box (pixels from the top-left) and enlarges it, so small text,
//       borders, padding and icon strokes become readable.
// grid  draws a labelled pixel grid over the image so you can read coordinates
//       and measure gaps before cropping.
// side  scales two images to the same width and joins them left/right, for
//       comparing a reference against a clone.
//
// Needs sharp once per machine:  npm install -g sharp

const { execSync } = require("child_process");
const path = require("path");

function loadSharp() {
  try { return require("sharp"); } catch {}
  try { return require(path.join(execSync("npm root -g").toString().trim(), "sharp")); } catch {}
  console.error("sharp is not installed. Run: npm install -g sharp");
  process.exit(1);
}
const sharp = loadSharp();

const argv = process.argv.slice(2);
const opt = (name, dflt) => { const i = argv.indexOf(name); return i === -1 ? dflt : argv[i + 1]; };
const pos = argv.filter((a, i) => !a.startsWith("--") && !(argv[i - 1] || "").startsWith("--"));
const [cmd, ...rest] = pos;

async function crop() {
  const [image, x0, y0, x1, y1] = [rest[0], ...rest.slice(1, 5).map(Number)];
  const scale = Number(opt("--scale", 3));
  const out = opt("--out", `crop-${x0}-${y0}-${x1}-${y1}.png`);
  const w = x1 - x0, h = y1 - y0;
  await sharp(image).extract({ left: x0, top: y0, width: w, height: h })
    .resize(w * scale, h * scale, { kernel: "lanczos3" }).png().toFile(out);
  console.log(`${out}  ${w * scale}x${h * scale}  (x${scale} of ${w}x${h})`);
}

async function grid() {
  const image = rest[0], step = Number(opt("--step", 100)), out = opt("--out", "grid.png");
  const { width, height } = await sharp(image).metadata();
  let svg = `<svg width="${width}" height="${height}" xmlns="http://www.w3.org/2000/svg">`;
  for (let x = 0; x < width; x += step)
    svg += `<line x1="${x}" y1="0" x2="${x}" y2="${height}" stroke="red" stroke-width="1"/><text x="${x + 2}" y="11" font-size="10" font-family="sans-serif" fill="red">${x}</text>`;
  for (let y = 0; y < height; y += step)
    svg += `<line x1="0" y1="${y}" x2="${width}" y2="${y}" stroke="red" stroke-width="1"/><text x="2" y="${y + 11}" font-size="10" font-family="sans-serif" fill="red">${y}</text>`;
  svg += "</svg>";
  await sharp(image).composite([{ input: Buffer.from(svg), top: 0, left: 0 }]).png().toFile(out);
  console.log(`${out}  ${width}x${height}  grid every ${step}px`);
}

async function side() {
  const [left, right] = rest, out = opt("--out", "side-by-side.png"), gap = 16;
  const [ml, mr] = await Promise.all([sharp(left).metadata(), sharp(right).metadata()]);
  const w = Math.min(ml.width, mr.width);
  const l = await sharp(left).resize({ width: w }).png().toBuffer({ resolveWithObject: true });
  const r = await sharp(right).resize({ width: w }).png().toBuffer({ resolveWithObject: true });
  const height = Math.max(l.info.height, r.info.height);
  await sharp({ create: { width: w * 2 + gap, height, channels: 3, background: "#ffffff" } })
    .composite([{ input: l.data, left: 0, top: 0 }, { input: r.data, left: w + gap, top: 0 }])
    .png().toFile(out);
  console.log(`${out}  ${w * 2 + gap}x${height}  left=${left} right=${right}`);
}

const cmds = { crop, grid, side };
if (!cmds[cmd]) { console.error("usage: zoom.js crop|grid|side …  (see header)"); process.exit(2); }
cmds[cmd]().catch((e) => { console.error(e.message); process.exit(1); });
