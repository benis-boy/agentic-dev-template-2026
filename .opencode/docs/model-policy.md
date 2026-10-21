# Model and Cost Policy

This policy was checked on 2026-10-19. Model IDs, provider availability, plan entitlements, and prices can change; verify against the active account before installation or changing a pin.

## Exact pins and role intent

- `design`, `agent-maintainer`, and emergency `heavy-subagent`: `github-copilot/gpt-6.1-sol` (Sol 6.1). `agent-maintainer` is a role-specific exception alongside Design and emergency Heavy.
- Normal subagents: `github-copilot/gpt-6-luna` (Luna 6), the newest Luna available in the inspected provider catalog. There is no `gpt-6.1-luna` in that catalog. Luna is used for bounded implementation, discovery, review, and tests.

These are role choices, not measured quality or speed claims. Keep exact IDs after account discovery. Do not use an unverified latest alias, silently replace a missing model, or rely on an automatic fallback. The installer must stop and report unavailable pins.

## Dated Copilot pricing context

GitHub Copilot's reported default tier for requests with up to 272K input tokens lists these USD-per-million-tokens rates as of 2026-10-19:

| Model | Input | Cached input | Cache write | Output |
| --- | ---: | ---: | ---: | ---: |
| GPT-6.1 Sol | $2.00 | $0.10 | $2.50 | $10.00 |
| GPT-6 Luna | $0.10 | $0.01 | $0.125 | $0.50 |

At that tier, Sol's input and output rates are 20 times Luna's, and cached input is 10 times Luna's. Long-context tiers cost more. Actual user cost and premium-request accounting depend on plan, model tier, token usage, and current billing policy; this table is not a universal bill estimate and does not establish that Sol is cheap or fast.

Use the smallest sufficient context and delegation count. Keep Sol for Design coordination, emergency Heavy work, and assigned agent-maintenance work; use Luna for normal leaf work. Prefer one coherent worker and tester assignments with targeted evidence to redundant parallel calls.

## Verify before changing pins

Use the installed runtime's CLI help to discover the supported model-listing syntax, then inspect the `github-copilot` account's available models. For current cost and model details, consult:

- [GitHub Copilot supported models](https://docs.github.com/en/copilot/reference/ai-models/supported-models)
- [GitHub Copilot model comparison](https://docs.github.com/en/copilot/reference/ai-models/model-comparison)
- [Copilot models and pricing](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing)

Do not run inference for installation or model-catalog discovery. Catalog inspection is sufficient to establish availability; any later live behavior verification belongs only in explicitly human-approved staging as described in the v2 migration guide. The human may make a deliberate reviewed pin change when an exact configured model is unavailable.
