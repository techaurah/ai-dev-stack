#!/usr/bin/env bash
# Stop the LiteLLM gateway started by start-gateway.sh
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [ -f "$ROOT/.gateway.pid" ]; then
  kill "$(cat "$ROOT/.gateway.pid")" 2>/dev/null && echo "Gateway stopped."
  rm -f "$ROOT/.gateway.pid"
else
  echo "No gateway pid file found."
fi
