#!/usr/bin/env bash
# Start the LiteLLM gateway for Claude Code (free-tier providers).
# Usage: ./start-gateway.sh [--port 4000]
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# Load keys from .env if present (never committed; see .env.example)
if [ -f "$ROOT/.env" ]; then set -a; . "$ROOT/.env"; set +a; fi

# This machine's default NO_PROXY contains bracketed IPv6 entries that crash
# LiteLLM's httpx client. Sanitize for this process only.
export NO_PROXY="localhost,127.0.0.1"
export no_proxy="localhost,127.0.0.1"
# Use the bundled model cost map (avoids a startup fetch that can fail behind proxies)
export LITELLM_LOCAL_MODEL_COST_MAP=True

# Gateway master key: use env, else generate once and store locally (mode 600, gitignored)
if [ -z "${LITELLM_MASTER_KEY:-}" ]; then
  KEYFILE="$ROOT/.gateway-key"
  if [ ! -f "$KEYFILE" ]; then
    umask 077; printf 'sk-local-%s' "$(head -c 24 /dev/urandom | od -An -tx1 | tr -d ' \n')" > "$KEYFILE"
  fi
  LITELLM_MASTER_KEY="$(cat "$KEYFILE")"
fi
export LITELLM_MASTER_KEY

PORT=4000
[ "${1:-}" = "--port" ] && PORT="${2:-4000}"

VENV="$ROOT/.venv-litellm"
[ -x "$VENV/bin/litellm" ] || { echo "LiteLLM venv missing. Run ./install.sh first."; exit 1; }

nohup "$VENV/bin/litellm" --config "$ROOT/gateway/litellm-config.yaml" --port "$PORT" \
  > "$ROOT/gateway.log" 2>&1 &
echo $! > "$ROOT/.gateway.pid"
for i in $(seq 1 30); do
  if curl -s -m 3 "http://127.0.0.1:$PORT/health/liveliness" >/dev/null 2>&1; then
    echo "Gateway live on http://127.0.0.1:$PORT (pid $(cat "$ROOT/.gateway.pid"), log: gateway.log)"
    exit 0
  fi
  sleep 3
done
echo "Gateway did not answer health checks in time. See gateway.log"; exit 1
