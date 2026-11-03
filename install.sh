#!/usr/bin/env bash
# ai-dev-stack installer: Claude Code + LiteLLM gateway + HyperFrames.
# Safe to re-run. Installs user-level tools only; no sudo, no system changes.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

# LiteLLM's HTTP client chokes on bracketed IPv6 entries present in some
# environments' NO_PROXY; sanitize for this process tree.
export NO_PROXY="localhost,127.0.0.1"
export no_proxy="localhost,127.0.0.1"

echo "==> Checking prerequisites"
command -v node >/dev/null || { echo "Node.js is required (>= 22). Install it first: https://nodejs.org"; exit 1; }
NODE_MAJOR="$(node -p 'process.versions.node.split(".")[0]')"
[ "$NODE_MAJOR" -ge 22 ] || { echo "Node >= 22 required (found $(node --version))."; exit 1; }
command -v python3 >/dev/null || { echo "python3 is required for the LiteLLM gateway."; exit 1; }
command -v ffmpeg >/dev/null || echo "WARN: ffmpeg not found; HyperFrames rendering needs it (https://ffmpeg.org)."

echo "==> Installing CLIs into ~/.npm-global (Claude Code, Claude Code Router, HyperFrames)"
mkdir -p "$HOME/.npm-global"
npm install -g --prefix "$HOME/.npm-global" \
  @anthropic-ai/claude-code @musistudio/claude-code-router hyperframes
export PATH="$HOME/.npm-global/bin:$PATH"
case ":$PATH:" in *":$HOME/.npm-global/bin:"*) : ;; *) echo "NOTE: add ~/.npm-global/bin to your PATH." ;; esac
claude --version || true
hyperframes --version || true

echo "==> Creating LiteLLM virtualenv (.venv-litellm)"
if [ ! -x ".venv-litellm/bin/litellm" ]; then
  python3 -m venv .venv-litellm
  .venv-litellm/bin/pip install -q --upgrade pip
  .venv-litellm/bin/pip install -q "litellm[proxy]"
fi
.venv-litellm/bin/litellm --version || true

echo "==> Preparing HyperFrames example assets (vendored GSAP, so renders work offline)"
GSAP="hyperframes/techaura-intro/assets/gsap.min.js"
if [ ! -f "$GSAP" ]; then
  mkdir -p "$(dirname "$GSAP")"
  for CDN in \
    "https://cdn.jsdelivr.net/npm/gsap@3.15.0/dist/gsap.min.js" \
    "https://cdnjs.cloudflare.com/ajax/libs/gsap/3.15.0/gsap.min.js" \
    "https://unpkg.com/gsap@3.15.0/dist/gsap.min.js"; do
    if curl -sL --max-time 60 --retry 2 --retry-delay 2 -o "$GSAP" "$CDN" && [ -s "$GSAP" ]; then break; fi
  done
  [ -s "$GSAP" ] || { echo "ERROR: could not download GSAP from any CDN mirror. Check your connection and re-run ./install.sh (it is safe to re-run)."; exit 1; }
fi

echo "==> Environment file"
if [ ! -f ".env" ]; then cp .env.example .env; echo "Created .env from .env.example - add at least one provider key."; fi

cat <<'EOF'

Done. Next steps:
  1. Put at least one free provider key in .env  (see docs/free-routes.md)
  2. ./scripts/start-gateway.sh
  3. ./scripts/claude-free.sh            (or: ./scripts/claude-free.sh -p "your task")
  4. ./scripts/render-intro.sh           (renders the HyperFrames example MP4)
EOF
