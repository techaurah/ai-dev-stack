# Free routes for Claude Code: the research (verified 2026-11-03)

Only legitimate free tiers and official programs, used with your own account. Leaked, shared,
or resold API keys (a common "free Claude Code" pattern in random repos and forums) violate
provider terms and get accounts banned; they are excluded here by design.

## How rerouting Claude Code works

Claude Code speaks the Anthropic Messages API. Three supported shapes:

1. **Direct custom endpoint**: `ANTHROPIC_BASE_URL` + `ANTHROPIC_AUTH_TOKEN` pointing at an
   Anthropic-compatible endpoint. OpenRouter offers one (`https://openrouter.ai/api`), so it
   needs no local software.
2. **Local gateway (this repo's setup)**: LiteLLM serves `/v1/messages` on localhost and
   translates to OpenAI-compatible providers. This unlocks NVIDIA, the strongest free tier.
3. **Claude Code Router** (MIT, github.com/musistudio/claude-code-router): per-scenario
   routing; a config template is in `gateway/`. Caveat from our testing: its current 3.x
   release is profile/UI driven and its raw gateway POST did not respond (see QA.md), so
   LiteLLM is the primary path here.

Anthropic's position, from its gateway docs: any gateway exposing a supported API format
works, but Anthropic does not endorse third-party gateways and does not support routing
Claude Code to non-Claude models. Treat this as off-label: features like MCP tool search
default off behind a custom base URL, and a Claude Code release can break the setup.

## Providers

### NVIDIA NIM (build.nvidia.com), rank 1
Free hosted inference for 100+ open models: DeepSeek V4 Pro/Flash (1M context), DeepSeek R1,
Qwen 3.x, Llama, GLM, Kimi, Mistral, Nemotron. Limits are per-request: up to 40 requests/min
and 10,000 requests/day on model pages, no per-token billing. Terms: prototyping, development
and research (production needs NVIDIA AI Enterprise), and trial terms let NVIDIA use prompts
to improve its models, so keep confidential code off it. OpenAI-compatible at
`https://integrate.api.nvidia.com/v1`. Sign-up: free developer account, no card; phone
verification usually required to activate a key; create the key with the Public API Endpoints
scope. Model IDs rotate; confirm the live ID on the model page.

### OpenRouter free models, rank 2
`:free` variants at $0/token plus an `openrouter/free` auto-router. Limits with no purchase:
20 requests/min and 50 requests/day (the 1,000/day tier needs $10 of lifetime purchases, so
it is not a $0 route). Small context windows on free models. Anthropic-compatible endpoint
`https://openrouter.ai/api`: the zero-install route. Sign-up: free account and key, no card.

### Groq, rank 3
Fast open-model inference, no card, not time-limited. 30 requests/min; per-model daily caps
from 14,400 requests (Llama 3.1 8B Instant) down to 1,000 (Llama 3.3 70B, GPT-OSS 120B), with
token-per-minute caps of 6K-12K that bind on long contexts. OpenAI-compatible at
`https://api.groq.com/openai/v1`. Sign-up at console.groq.com takes about a minute.

### Google AI Studio (Gemini API), rank 4
Flash models free, no card, no expiry, roughly 10 requests/min and 1,500 requests/day
(per-project, shown in the AI Studio rate-limit console), ~1M context. Two catches: free-tier
prompts may be used to train Google's models, and since a 2026 change, Gemini 2.5 models are
served only to accounts that already used them; new projects start on Gemini 3.x Flash. Our
config alias names `gemini-2.5-flash`; new accounts should point it at the current Flash
model in AI Studio. OpenAI-compatible endpoint available; this repo uses LiteLLM's native
Gemini provider.

### GitHub Models, rank 5
Free with a GitHub account: GPT-4o, Llama, DeepSeek, Mistral and more. Limits are for
experimentation by design: high-tier 10 requests/min and 50/day, low-tier 15/min and 150/day,
per-request caps near 8K input and 4K output tokens, which rules out full agent sessions but
suits one-shot evaluations. OpenAI-compatible at `https://models.github.ai/inference`.
Auth is a fine-grained personal access token with only the `models:read` permission
(Settings, Developer settings, Personal access tokens). Free-tier terms bar production use.

## Checked and excluded

- **Together AI**: widely advertised "free credits" are not real. Together's docs state
  there are no free trials and access requires a prepaid credit purchase.
- **Hyperbolic**: $0-deposit Basic tier (60 requests/min) but pay-per-token usage; the only
  free element ever documented is a ~$1 trial credit after phone verification. Not a free
  tier in practice.
- **Hugging Face**: free-account inference credit is down to about $0.10/month; negligible.
- **Anthropic**: no free API tier (a one-time ~$5 Console trial credit exists; a trial, not
  a route).
- **Referral-credit gateways and key-sharing repos**: excluded on terms and safety grounds.

## Sources (checked 2026-11-03)

- Anthropic, Connect Claude Code to an LLM gateway, code.claude.com/docs
- OpenRouter, Claude Code with OpenRouter, openrouter.ai/blog/tutorials/claude-code-openrouter
- NVIDIA NIM free tier analyses: klymentiev.com/blog/nvidia-nim-free-credits, big-agi.com/nvidia
- GitHub Models docs and rate limits, docs.github.com/en/github-models
- Groq rate limits, console.groq.com/docs/rate-limits
- Gemini API pricing and free tier, ai.google.dev/gemini-api/docs/pricing
- Together AI billing docs, docs.together.ai/docs/billing-credits
- Hyperbolic pricing tiers, via freetokens.custats.info/offers/hyperbolic-basic-free-tier.html
