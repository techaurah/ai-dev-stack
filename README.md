# ai-dev-stack

**Run Claude Code on free model tiers, and render branded motion graphics from HTML. One clone, one install script, your own free API keys.**

![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)
![Node](https://img.shields.io/badge/node-%3E%3D22-green.svg)
![Python](https://img.shields.io/badge/python-3.10%2B-blue.svg)

ai-dev-stack is TechAurah's reusable developer setup. It packages two things we run in
production ourselves:

| Part | What it does |
| --- | --- |
| **Claude Code on free tiers** | Points the Claude Code CLI at a local LiteLLM gateway backed by free hosted model tiers (NVIDIA NIM first), so agentic coding runs at $0 without an Anthropic subscription |
| **HyperFrames motion graphics** | Renders deterministic, branded MP4 motion cards from HTML/CSS/GSAP compositions (HeyGen's open-source HyperFrames), for social content pipelines |

## Status, stated plainly

- Installed and chain-tested on our machine on 2026-11-03: Claude Code reaches the gateway,
  the gateway translates and forwards to the provider, and the chain stops only at the
  provider credential check. Add one real free key (step 2 below) and it runs.
- The HyperFrames example renders end to end: verified MP4, 1280x720, 30 fps, 4 s,
  byte-identical across re-renders.
- Full test evidence lives in [QA.md](QA.md). Nothing here is claimed beyond what was tested.

## Quick start

```bash
git clone https://github.com/techaurah/ai-dev-stack.git
cd ai-dev-stack
cp .env.example .env      # add at least ONE free provider key (see docs/free-routes.md)
./install.sh              # Claude Code + routers + LiteLLM venv + HyperFrames (~5 min)
./scripts/start-gateway.sh
./scripts/claude-free.sh -p "Explain what this repository does"
```

Render the motion-graphics example:

```bash
./scripts/render-intro.sh   # writes hyperframes/techaura-intro/renders/*.mp4
```

## Requirements

- Node.js 22 or newer, Python 3.10+, FFmpeg (for HyperFrames rendering)
- One free account/API key from any supported provider (NVIDIA recommended; no credit card
  anywhere in the ranked list)
- About 2 GB free disk for toolchains; renders need temp space (see Troubleshooting)

## Free routes, ranked

Researched and verified 2026-11-03. Only official free tiers with your own account; no shared
or leaked keys, ever. Full research with sources: [docs/free-routes.md](docs/free-routes.md).

| Rank | Provider | Free allowance | Used for |
| --- | --- | --- | --- |
| 1 | NVIDIA NIM (build.nvidia.com) | Up to 40 req/min, 10,000 req/day, no per-token billing | Default + reasoning slots (DeepSeek V4) |
| 2 | OpenRouter `:free` models | 20 req/min, 50 req/day | Fallback alias; also works with no gateway at all |
| 3 | Groq | 30 req/min; up to 14,400 req/day on small models | Background (haiku) slot |
| 4 | Google AI Studio | ~1,500 req/day on Flash, ~1M context | Long-context alias |
| 5 | GitHub Models | 50-150 req/day, ~8K input cap | One-shot evaluations (GPT-4o) |

## How it works

Claude Code speaks the Anthropic Messages API. The LiteLLM gateway listens on
`http://127.0.0.1:4000`, accepts those requests, and translates them to OpenAI-compatible
free providers. Model slots map by job: the opus slot gets the strongest free reasoning
model, the sonnet slot the default coding workhorse, the haiku slot the fastest cheap model.
Keys are read from environment variables (`.env`), never from committed files. A Claude Code
Router config template is included under `gateway/` as an alternative gateway.

Two honest caveats: Anthropic does not support routing Claude Code to non-Claude models
through gateways, so this is an off-label setup that can break with a Claude Code release;
and the answers come from open models, not Claude, so quality is the model's own.

## HyperFrames example

`hyperframes/techaura-intro/` is a 4-second branded title card (navy/cyan TechAura card,
GSAP intro animation). Edit the text and colors in `index.html`, then render with
`./scripts/render-intro.sh`. Rendering is deterministic: same input, same MP4. Background
and the lessons baked into the scripts (temp-space redirect, vendored animation library):
[docs/hyperframes.md](docs/hyperframes.md).

Note: HyperFrames output is rendered HTML animation. It is a motion-design format, not
AI-generated video, and should never be labeled as such.

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| LiteLLM crashes at startup with `InvalidURL ... Invalid port` | Your `NO_PROXY` contains bracketed IPv6 entries that break its HTTP client. `start-gateway.sh` already sanitizes this; if you start LiteLLM by hand, set `NO_PROXY=localhost,127.0.0.1` |
| LiteLLM refuses to start: `UnsafeMasterKeyError` | Current LiteLLM requires a master key. `start-gateway.sh` generates `.gateway-key` automatically (mode 600, gitignored) |
| Claude Code says `Failed to authenticate ... 403 ... Authorization failed` | The gateway is fine; the provider rejected your key. Check the key in `.env` is real and active |
| HyperFrames: `Low disk space ... at /tmp` | Renders need temp space. `render-intro.sh` already redirects `TMPDIR` into the project; do the same for custom renders |
| HyperFrames render blocked: timeline script failure on a CDN URL | Animation libraries must be local inside the render sandbox. `install.sh` vendors GSAP into the example's `assets/`; reference local files, not CDN URLs |
| Provider returns 404 for a model | Free catalogs rotate and retire model IDs. Confirm the current ID on the provider's model page and update `gateway/litellm-config.yaml` |
| `No space left on device` during install | The toolchain needs roughly 2 GB free on the filesystem holding the clone (npm cache, pip wheels, the LiteLLM venv). Clone onto a roomy filesystem; some sandboxes mount `/tmp` at only a few hundred MB |

## Repository layout

```
install.sh                    one-shot installer (idempotent)
.env.example                  every key documented, all optional individually
gateway/                      LiteLLM config + Claude Code Router template
scripts/                      start/stop gateway, claude-free launcher, render script
hyperframes/techaura-intro/   example composition (source only)
docs/                         free-routes research, HyperFrames notes
QA.md                         what was tested, expected vs actual, evidence
```

## Contributing

Issues and improvements welcome; see [CONTRIBUTING.md](CONTRIBUTING.md). Please never open
an issue containing an API key or token.

## License

MIT, see [LICENSE](LICENSE). Built by [TechAurah](https://techaurah.com), AI and software
engineering. HyperFrames is Apache-2.0 (HeyGen); GSAP is used under its standard license;
Claude Code, LiteLLM and Claude Code Router belong to their respective owners.
