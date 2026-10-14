#!/bin/bash
# FFmpeg for the agent: look at a video as still frames, and make videos light
# enough for a storefront. VIDEO can be a file or an https address.
#
#   video.sh setup                                   (from setup: installs ffmpeg + ffprobe)
#   video.sh frames VIDEO [--count 8] [--out DIR]    evenly spaced frames + one contact sheet
#   video.sh web VIDEO [--width 1080] [--audio] [--out OUT.mp4]
#                                                    H.264 .mp4 for the web, plus a poster .jpg
#   video.sh ffmpeg ARGS... | video.sh ffprobe ARGS...   anything else
#
# Setup downloads Martin Riedl's static macOS builds into ~/.local/bin: no
# password, no Homebrew, no install script for npm to block. An ffmpeg already
# on the PATH (Homebrew's, say) is used as it is.
BIN_DIR="$HOME/.local/bin"
BUILDS="https://ffmpeg.martin-riedl.de/redirect/latest/macos"

find_tool() {
  if [ -x "$BIN_DIR/$1" ]; then echo "$BIN_DIR/$1"; return; fi
  for dir in /opt/homebrew/bin /usr/local/bin; do
    if [ -x "$dir/$1" ]; then echo "$dir/$1"; return; fi
  done
  command -v "$1" 2>/dev/null
}

need_tools() {
  FFMPEG="$(find_tool ffmpeg)"
  FFPROBE="$(find_tool ffprobe)"
  if [ -z "$FFMPEG" ] || [ -z "$FFPROBE" ]; then
    echo "ffmpeg is not installed. Run: bash $0 setup" >&2
    exit 1
  fi
}

setup() {
  if [ -n "$(find_tool ffmpeg)" ] && [ -n "$(find_tool ffprobe)" ]; then
    "$(find_tool ffmpeg)" -hide_banner -version | head -1
    echo "Already installed."
    return 0
  fi
  case "$(uname -m)" in
    arm64) arch=arm64 ;;
    x86_64) arch=amd64 ;;
    *) echo "No ffmpeg build for $(uname -m)." >&2; return 1 ;;
  esac
  mkdir -p "$BIN_DIR"
  tmp="$(mktemp -d)"
  for tool in ffmpeg ffprobe; do
    curl -fsSL -o "$tmp/$tool.zip" "$BUILDS/$arch/release/$tool.zip" &&
      unzip -oq "$tmp/$tool.zip" -d "$tmp" &&
      mv -f "$tmp/$tool" "$BIN_DIR/$tool" &&
      chmod +x "$BIN_DIR/$tool" || { echo "Downloading $tool failed." >&2; rm -rf "$tmp"; return 1; }
  done
  rm -rf "$tmp"
  "$BIN_DIR/ffmpeg" -hide_banner -version | head -1
}

# Prints duration, size, frame rate, sound and file size, the way a person would ask.
describe() {
  local d w h fps audio bytes
  d="$("$FFPROBE" -v error -show_entries format=duration -of default=nw=1:nk=1 "$1")"
  IFS=, read -r w h fps <<<"$("$FFPROBE" -v error -select_streams v:0 -show_entries stream=width,height,avg_frame_rate -of csv=p=0 "$1")"
  audio="$("$FFPROBE" -v error -select_streams a -show_entries stream=codec_type -of csv=p=0 "$1" | head -1)"
  bytes="$("$FFPROBE" -v error -show_entries format=size -of default=nw=1:nk=1 "$1")"
  printf 'duration %.1fs · %sx%s · %s fps · %s · %s\n' "${d:-0}" "$w" "$h" \
    "$(awk -v f="$fps" 'BEGIN { split(f, p, "/"); printf "%.0f", (p[2] ? p[1] / p[2] : p[1]) }')" \
    "$([ -n "$audio" ] && echo "has sound" || echo "no sound")" \
    "$(awk -v b="$bytes" 'BEGIN { printf (b > 1048576 ? "%.1f MB" : "%.0f KB"), (b > 1048576 ? b / 1048576 : b / 1024) }')"
}

frames() {
  local video="$1" count=8 out="" d i t cols rows
  shift
  while [ $# -gt 0 ]; do
    case "$1" in
      --count) count="$2"; shift 2 ;;
      --out) out="$2"; shift 2 ;;
      *) echo "Unknown option $1" >&2; exit 2 ;;
    esac
  done
  out="${out:-$(mktemp -d)/frames}"
  mkdir -p "$out"
  describe "$video"
  d="$("$FFPROBE" -v error -show_entries format=duration -of default=nw=1:nk=1 "$video")"
  for i in $(seq 1 "$count"); do
    t="$(awk -v d="${d:-0}" -v i="$i" -v n="$count" 'BEGIN { printf "%.2f", d * (i - 0.5) / n }')"
    "$FFMPEG" -v error -y -ss "$t" -i "$video" -frames:v 1 "$out/frame-$(printf %02d "$i")-${t}s.png"
  done
  # One image of every frame in order, left to right then down, for a first look.
  cols=$(( count < 4 ? count : 4 ))
  rows=$(( (count + cols - 1) / cols ))
  "$FFMPEG" -v error -y -pattern_type glob -i "$out/frame-*.png" \
    -vf "scale=480:-2,tile=${cols}x${rows}:padding=8:color=white" -frames:v 1 "$out/sheet.jpg"
  echo "$out/sheet.jpg"
  ls "$out"/frame-*.png
}

web() {
  local video="$1" width=1080 audio="-an" out=""
  shift
  while [ $# -gt 0 ]; do
    case "$1" in
      --width) width="$2"; shift 2 ;;
      --audio) audio="-c:a aac -b:a 128k"; shift ;;
      --out) out="$2"; shift 2 ;;
      *) echo "Unknown option $1" >&2; exit 2 ;;
    esac
  done
  out="${out:-$(mktemp -d)/$(basename "${video%.*}")-web.mp4}"
  mkdir -p "$(dirname "$out")"
  echo "before: $(describe "$video")"
  # Never enlarged; even dimensions for H.264; faststart so playback begins before the download ends.
  # shellcheck disable=SC2086
  "$FFMPEG" -v error -y -i "$video" \
    -vf "scale='min($width,iw)':-2:flags=lanczos,format=yuv420p" \
    -c:v libx264 -preset slow -crf 26 -movflags +faststart $audio "$out" || exit 1
  "$FFMPEG" -v error -y -i "$out" -frames:v 1 -q:v 3 "${out%.*}-poster.jpg"
  echo "after:  $(describe "$out")"
  echo "$out"
  echo "${out%.*}-poster.jpg"
}

cmd="$1"
shift
case "$cmd" in
  setup) setup ;;
  frames) need_tools; frames "$@" ;;
  web) need_tools; web "$@" ;;
  ffmpeg) need_tools; exec "$FFMPEG" "$@" ;;
  ffprobe) need_tools; exec "$FFPROBE" "$@" ;;
  *) echo "usage: video.sh setup|frames|web|ffmpeg|ffprobe …  (see header)" >&2; exit 2 ;;
esac
