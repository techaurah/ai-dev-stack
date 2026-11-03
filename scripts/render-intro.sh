#!/usr/bin/env bash
# Render the HyperFrames example composition (TechAura intro card) to MP4.
# Note: renders write large temp files. If /tmp is small on your machine, this
# script already redirects TMPDIR into the project folder.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJ="$ROOT/hyperframes/techaura-intro"
mkdir -p "$PROJ/.tmp"
export PATH="$HOME/.npm-global/bin:$PATH"
cd "$PROJ"
TMPDIR="$PROJ/.tmp" npx --yes hyperframes@0.9.6 render
ls -la renders/
