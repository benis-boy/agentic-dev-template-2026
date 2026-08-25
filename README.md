# Agentic Development Template 2026

This repository provides a compact parent-subagent setup for software projects. It intentionally uses one primary design agent, a small set of broadly useful subagents, and dedicated frontend and backend test executors rather than one agent per language or framework.

To install it into a project, ask a capable coding agent to read and execute [`install.md`](install.md) from the destination repository. The installer must inspect that project, resolve every placeholder in installed files, merge rather than overwrite existing project guidance, notify the human about the required end-to-end runner follow-up, and leave the result for human review.

## Design Decisions

### One Primary Coordinator

`design` is the only user-facing primary agent. It runs on `github-copilot/gpt-5.6-sol` and owns decomposition, delegation, integration, and final verification. It implements very small fixes directly when delegation would cost more than the work.

Keeping coordination in one place avoids competing planners and fragmented ownership. The design agent receives a small, distinct menu of subagents, which makes automatic routing more reliable.

### Context-Isolated Subagents

The normal implementation, exploration, review, and test subagents run on `github-copilot/gpt-5.6-luna`:

- `luna-worker` implements one bounded change within explicit ownership.
- `luna-scout` maps unfamiliar code and recommends an implementation boundary.
- `luna-reviewer` audits a supplied change for concrete defects and test gaps.
- `backend-tester` validates backend, service, script, and backend end-to-end behavior.
- `frontend-tester` validates UI, browser, accessibility, and frontend end-to-end behavior.

`heavy-subagent` runs on `github-copilot/gpt-5.6-sol` and is reserved for bounded emergency work that requires deeper reasoning after a specialized agent fails or cannot safely isolate the task.

These roles are organized primarily by work phase, with separate test executors where environment and evidence boundaries differ. A general worker can handle application code, migrations, documentation, or infrastructure when given the right scope and project constraints. This avoids flooding the parent with overlapping specialists.

### Shallow Delegation

The config sets `subagent_depth` to `1`. Subagents provide context isolation and bounded execution; they do not create deeper delegation trees. Independent implementation slices may run in parallel, but one coherent worker is preferred by default.

### Permissions Encode Boundaries

The scout and reviewer deny edits, while the test executors may request permission to correct tests within their narrow assignments. The reviewer also restricts shell usage to read-only Git inspection. These boundaries live in configuration instead of being repeated as prompt prose.

### Structured Returns

Each subagent has a role-specific Markdown return contract. Stable sections make it easier for the design agent to integrate outcomes, distinguish evidence from assumptions, and identify remaining work without imposing a brittle machine-only format.

### Living Project Context

The included `AGENTS.md` is a durable context template, not a command encyclopedia. It prioritizes product goals, system boundaries, repository invariants, canonical workflows, and cross-cutting reliability rules that should be available in every agent session.

The product-goals section explicitly requires updates alongside changes to product direction or system-of-record decisions. This keeps project context versioned and reviewable as the product evolves.

## Model Requirements

The supplied files use these exact GitHub Copilot model IDs:

- Primary and emergency heavy subagent: `github-copilot/gpt-5.6-sol`
- Normal subagents: `github-copilot/gpt-5.6-luna`

The installer should verify both IDs against the destination model provider before enabling the template. It must not silently substitute another model or rely on fallback behavior.

## Contents

- The bundled runtime configuration: default-agent, depth, and built-in-agent settings.
- `design.md`: primary coordinator.
- Agent definitions for implementation, exploration, review, frontend testing, backend testing, and bounded emergency work.
- `AGENTS.md`: project-context template.
- `action-driven-design`: skill for maintaining action-oriented `*-feature.md` design records.
- `.agents/skills/playwright-cli`: official Microsoft Playwright CLI skill for browser automation. Installation also requires the matching `@playwright/cli` executable and a successful browser smoke check described in `install.md`.
- `.opencode/docs/e2e-runner-feature.md`: required end-to-end runner implementation plan. The installer does not install or customize it automatically; it must notify the human to handle the plan for the destination project because reliable end-to-end proof is required for proper agentic development.
- `install.md`: agent-oriented installation procedure.
