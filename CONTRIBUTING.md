# Contributing

Thanks for looking. This repo is TechAurah's own working setup, shared so others can reuse
it; small, focused changes are the most useful kind.

## Ground rules

- Never commit secrets. No API keys, tokens, `.env` files, or generated gateway keys, in
  code, docs, issues, or screenshots. Config files reference environment variables only.
- Keep the honesty standard: if a provider limit or behavior changes, update
  `docs/free-routes.md` with the date and the source you checked.
- Scripts must stay idempotent and user-level (no sudo, no system package installs).

## Making a change

1. Fork or branch.
2. Make the smallest change that does the job.
3. If you touch the gateway config or scripts, run the smoke test: start the gateway with
   dummy keys and confirm a request is forwarded (an upstream 403 with dummy keys is the
   expected pass signal; see QA.md).
4. If you touch the HyperFrames example, run `hyperframes check` in the composition folder
   and render once before submitting.
5. Open a pull request describing what changed, why, and what you tested.

## Reporting a problem

Open an issue with your OS, Node and Python versions, the exact command, and the exact
error. Redact anything that looks like a key before posting logs.
