#!/usr/bin/env bash
# Run Claude Code against the local LiteLLM gateway (free-tier models).
# Start the gateway first: ./scripts/start-gateway.sh
# Any args are passed through to `claude` (e.g. ./scripts/claude-free.sh -p "task")
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [ -f "$ROOT/.env" ]; then set -a; . "$ROOT/.env"; set +a; fi
if [ -z "${LITELLM_MASTER_KEY:-}" ] && [ -f "$ROOT/.gateway-key" ]; then
  LITELLM_MASTER_KEY="$(cat "$ROOT/.gateway-key")"
fi
: "${LITELLM_MASTER_KEY:?No gateway key found. Start the gateway once so it generates .gateway-key, or set LITELLM_MASTER_KEY.}"

export ANTHROPIC_BASE_URL="http://127.0.0.1:4000"
export ANTHROPIC_AUTH_TOKEN="$LITELLM_MASTER_KEY"
export ANTHROPIC_MODEL="claude-sonnet-slot"
export ANTHROPIC_DEFAULT_SONNET_MODEL="claude-sonnet-slot"
export ANTHROPIC_DEFAULT_OPUS_MODEL="claude-opus-slot"
export ANTHROPIC_DEFAULT_HAIKU_MODEL="claude-haiku-slot"

CLAUDE_BIN="$(command -v claude || echo "$HOME/.npm-global/bin/claude")"
exec "$CLAUDE_BIN" "$@"
