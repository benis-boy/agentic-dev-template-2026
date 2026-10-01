# Agentic Development Template 2026

This repository provides a compact parent-subagent setup for software projects. It intentionally uses one primary design agent, a small set of broadly useful subagents, dedicated frontend and backend test executors, and a goal-oriented design workflow rather than one agent per language or framework.

To install it into a project, ask a capable coding agent to read and execute [`install.md`](install.md) from the destination repository. The installer must inspect that project, resolve every placeholder in installed files, merge rather than overwrite existing project guidance, notify the human about the required end-to-end runner follow-up, and leave the result for human review.

## Design Decisions

### One Primary Coordinator

`design` is the only user-facing primary agent. It runs on `github-copilot/gpt-6.1-sol` and owns decomposition, routing, integration, and independent final verification. It implements very small fixes directly when delegation would cost more than the work, but does not run tests itself.

Keeping coordination in one place avoids competing planners and fragmented ownership. The design agent receives a small, distinct menu of subagents, which makes automatic routing more reliable.

### Context-Isolated Subagents

The normal implementation, exploration, review, and test subagents run on `github-copilot/gpt-6-luna`:

- `luna-worker` implements one bounded change within explicit ownership.
- `luna-scout` maps unfamiliar code and recommends an implementation boundary.
- `luna-reviewer` audits a supplied change for concrete defects and test gaps.
- `backend-tester` validates backend, service, script, and backend end-to-end behavior.
- `frontend-tester` validates UI, browser, accessibility, and frontend end-to-end behavior.

`heavy-subagent` runs on `github-copilot/gpt-6.1-sol` and is reserved for bounded emergency work that requires deeper reasoning after a specialized agent fails or cannot safely isolate the task.

These roles are organized primarily by work phase, with separate test executors where environment and evidence boundaries differ. A general worker can handle application code, migrations, documentation, or infrastructure when given the right scope and project constraints. This avoids flooding the parent with overlapping specialists.

### Bounded Delegation

The config sets `subagent_depth` to `2` to support an explicitly bounded emergency delegation when Design supplies the permitted target names, purpose, and self-contained context. Design alone owns routing and supplies any heavy-subagent delegation targets; normal agents are ordinarily leaves and do not receive a peer-role catalogue. Independent implementation slices may run in parallel, but one coherent worker is preferred by default.

Workers add or update focused tests, run only the exact cases they changed, and fix scoped failures locally. They do not run unchanged suites or broaden checks when case isolation is unsupported. This fast author-local feedback is distinct from independent final verification: Design delegates broader or independent checks to the dedicated backend or frontend testers and does not execute tests itself. For UI locator attributes, Design arranges any Scout inspection and passes its file-and-line findings and the exact UI-source allowlist to the frontend tester; the tester does not need a nested Scout handoff.

### Permissions Encode Boundaries

The scout and reviewer deny edits, while the test executors may request permission to correct tests within their narrow assignments. The reviewer also restricts shell usage to read-only Git inspection. Skills are deny-by-default and assigned by role: orchestration to Design, coding to implementers and reviewers, testing to executors, and no skills to Scout unless the destination proves a need. These boundaries live in configuration instead of being repeated as prompt prose.

### Structured Returns

Each subagent has a role-specific Markdown return contract. Stable sections make it easier for the design agent to integrate outcomes, distinguish evidence from assumptions, and identify remaining work without imposing a brittle machine-only format.

### Living Project Context

The included `AGENTS.md` is a durable context template, not a command encyclopedia. It prioritizes product goals, system boundaries, repository invariants, canonical workflows, and cross-cutting reliability rules that should be available in every agent session.

The product-goals section explicitly requires updates alongside changes to product direction or system-of-record decisions. This keeps project context versioned and reviewable as the product evolves. The bundled `goal-oriented-design` skill adds goal trees, proof inventories, and plain-text outcome handoffs to orchestration.

## Model Requirements

The supplied files use these exact GitHub Copilot model IDs:

- Primary and emergency heavy subagent: `github-copilot/gpt-6.1-sol`
- Normal subagents: `github-copilot/gpt-6-luna`

The installer should verify both IDs against the destination model provider before enabling the template. It must not silently substitute another model or rely on fallback behavior.

## Contents

- The bundled runtime configuration: default-agent, depth, and built-in-agent settings.
- `design.md`: primary coordinator.
- Agent definitions for implementation, exploration, review, frontend testing, backend testing, and bounded emergency work.
- `AGENTS.md`: project-context template.
- `.opencode/skills/playwright-cli`: official Microsoft Playwright CLI skill for browser automation. Installation also requires the matching `@playwright/cli` executable and a successful browser smoke check described in `install.md`.
- `.opencode/skills/goal-oriented-design`: reusable goal mapping, status, proof, and independent-library lifecycle workflow.
- `.opencode/commands/init-goals.md`: human-triggered fresh-session initialization command; invoke `/init-goals` after restart and approve candidates before authoritative writes.
- `.opencode/docs/e2e-runner-feature.md`: required end-to-end runner implementation plan. The installer does not install or customize it automatically; it must notify the human to handle the plan for the destination project because reliable end-to-end proof is required for proper agentic development.
- `install.md`: agent-oriented installation procedure.
