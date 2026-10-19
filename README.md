# Agentic Development Template 2026

This repository provides a compact parent-subagent setup for software projects. It intentionally uses one primary design agent, a small set of broadly useful subagents, dedicated frontend and backend test executors, and a goal-oriented design workflow rather than one agent per language or framework.

To install it into a project, ask a capable coding agent to read and execute [`install.md`](install.md) from the destination repository. The installer must inspect that project, resolve every placeholder in installed files, merge rather than overwrite existing project guidance, notify the human about the required end-to-end runner follow-up, and leave the result for human review. For an existing installation, use [`update.md`](update.md) from the destination root instead; it reconciles drift without rerunning first-install side effects or discarding local improvements.

After installation, the human may optionally invoke `/devcontainer` in a destination project to create or adapt that project's root `.devcontainer`; optional constraints can follow the command (for example, a required target platform). Installation itself only copies the command and guide—it does not generate a devcontainer, install OpenCode v2, or stage credentials. This reusable workflow is distinct from `/init-goals` and does not initialize or edit goal documentation.

## Design Decisions

### One Primary Coordinator

`design` is the only user-facing primary agent. It runs on `github-copilot/gpt-6.1-sol` and owns planning, routing, context-rich handoffs, and integration. It may implement a tiny fix directly only when clearly cheaper than delegation; it never runs tests.

Keeping coordination in one place avoids competing planners and fragmented ownership. The design agent receives a small, distinct menu of subagents, which makes automatic routing more reliable.

### Context-Isolated Subagents

The normal implementation, exploration, review, and test subagents run on `github-copilot/gpt-6-luna`:

- `luna-worker` implements one bounded change and authors focused tests; it returns test commands unexecuted and does not independently verify.
- `luna-scout` performs read-only local/upstream discovery; it never edits or runs tests.
- `luna-reviewer` independently audits a supplied change; it never edits or runs tests.
- `backend-tester` executes backend, service, script, configuration, static, and backend end-to-end validation, and may correct tests.
- `frontend-tester` executes UI, browser, accessibility, frontend static, and end-to-end validation; it may correct tests and make only exact-file allowlisted locator-attribute edits.

`heavy-subagent` runs on `github-copilot/gpt-6.1-sol` and is an emergency replacement owner for exactly one explicit reconnaissance, diagnosis, implementation, or read-only review mode after a specialist fails, evidence conflicts, or a coupled task cannot safely fit one specialist. It is not a duplicate concurrent owner or self-certifier; implementation authors focused tests but does not execute them.

These roles are organized primarily by work phase, with separate test executors where environment and evidence boundaries differ. A general worker can handle application code, migrations, documentation, or infrastructure when given the right scope and project constraints. This avoids flooding the parent with overlapping specialists.

### Bounded Delegation and Test Ownership

Role descriptions and prompts express intended responsibility and ownership, not enforced rights. Design normally coordinates work, and the subagent prompts preserve worker, scout, reviewer, and tester intent; those instructions do not restrict which tools, skills, files, or delegation targets an agent can technically access. This trusted-project template does not use OpenCode permission prompts or role allowlists as a security boundary. The active root config and every supplied agent explicitly allow permissions.

Workers add or update focused tests and return recommended commands without executing them. Ownership is exclusive by stage: the implementation owner may address scoped implementation and authored-test failures; once validation is assigned, `backend-tester` or `frontend-tester` owns test execution and test corrections, with no concurrent edits to the same tests. Testers are instructed not to repair product behavior or the environment; those are role instructions, not technical access controls. For UI locator attributes, Design arranges any Scout inspection and passes findings, intended semantics, and the exact UI-source allowlist to the frontend tester. Prefer stable exact test IDs or titles, with paths only to disambiguate.

### Role Instructions Do Not Enforce Rights

Scout's read-only discovery, Reviewer's read-only audit, and tester-only execution are task instructions, not permission restrictions. A role's expected scope does not limit its technical ability to access tools, skills, arbitrary files, or network resources. The project is assumed to have trusted, controlled inputs and network; this template is not a prompt-injection security boundary. External operating-system, runtime, or organizational controls may still restrict actions and are outside this template's authority.

### Structured Returns

Each subagent has a role-specific Markdown return contract. Stable sections make it easier for the design agent to integrate outcomes, distinguish evidence from assumptions, and identify remaining work without imposing a brittle machine-only format.

### Living Project Context

The included `AGENTS.md` is a durable context template, not a command encyclopedia. It prioritizes product goals, system boundaries, repository invariants, canonical workflows, and cross-cutting reliability rules that should be available in every agent session.

The product-goals section explicitly requires updates alongside changes to product direction or system-of-record decisions. This keeps project context versioned and reviewable as the product evolves. The bundled `goal-oriented-design` skill adds goal trees, proof inventories, and plain-text outcome handoffs to orchestration.

## Model and Cost Policy

The supplied files pin these exact GitHub Copilot model IDs; the installer verifies availability and never silently substitutes a model or depends on fallback behavior:

- Primary and emergency heavy subagent: `github-copilot/gpt-6.1-sol`
- Normal subagents: `github-copilot/gpt-6-luna`

Design uses Sol 6.1 for orchestration and heavy emergency work; Luna 6 is the normal subagent choice for bounded implementation, discovery, review, and testing. These are qualitative role choices, not comparative benchmark claims. Account availability and model catalog change; pin the exact discovered IDs and do not use an unverified latest alias or automatic substitute. See [model policy](.opencode/docs/model-policy.md) for dated pricing context and cost-conscious use.

This checkout is known to have OpenCode `1.18.35`. The reported latest stable release on 2026-10-19 is `1.19.3` (Oct 16); v2 docs/distribution are a separate channel. This template does not upgrade runtime, packages, or credentials. See the [v2 migration readiness guide](.opencode/docs/opencode-v2-migration.md); its staging path is planned, not verified runtime support. The separate opt-in `/devcontainer` command targets the destination's OpenCode v2 environment; it does not change the template runtime or remove the standard installer's v1 compatibility gate.

## Contents

- The bundled v1 runtime configuration: default-agent and built-in-agent settings.
- `.opencode/agents/design.md`: primary coordinator.
- Agent definitions for implementation, exploration, review, frontend testing, backend testing, and bounded emergency work.
- `AGENTS.md`: project-context template.
- `.opencode/skills/playwright-cli`: official Microsoft Playwright CLI skill for browser automation. Installation also requires the matching `@playwright/cli` executable and a successful browser smoke check described in `install.md`.
- `.opencode/skills/goal-oriented-design`: reusable goal mapping, status, proof, and independent-library lifecycle workflow.
- `.opencode/commands/init-goals.md`: human-triggered fresh-session initialization command; invoke `/init-goals` after restart and approve candidates before authoritative writes.
- `.opencode/commands/devcontainer.md` and `.opencode/docs/devcontainer.md`: opt-in workflow and operational guide for adapting a destination project to a reproducible devcontainer with OpenCode v2, host-auth staging gates, and durable sessions. Template installation only copies these files; it does not generate a devcontainer.
- `.opencode/docs/e2e-runner-feature.md`: required end-to-end runner implementation plan. The installer does not install or customize it automatically; it must notify the human to handle the plan for the destination project because reliable end-to-end proof is required for proper agentic development.
- `install.md`: agent-oriented installation procedure.
- `update.md`: destination-root workflow for behavior-based reconciliation of an existing installation, including v2 targets and local improvements.
- `.opencode/docs/model-policy.md`: model pins, dated Copilot pricing context, and cost policy.
- `.opencode/docs/opencode-v2-migration.md`: separate staging plan and unverified migration gates.
