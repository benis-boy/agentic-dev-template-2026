# Agent Relationships and Context

This page is a human-oriented explanation and navigation aid for the supplied roles. It is not an agent's operational source, is not automatically loaded, and does not establish permissions or replace applicable `AGENTS.md`, task context, or role prompts. Those prompts carry the operational knowledge each role needs; Design does not need to read this page to route work.

## Shared context and role map

An agent's working context is applicable root and nested `AGENTS.md`, its own prompt, and explicit task or handoff context. Parents' and siblings' prompts are not automatically shared, and a Markdown link does not load its target. The root [`AGENTS.md`](../../AGENTS.md) is a project-context template and retains placeholders until adapted in a destination project.

- [`design.md`](../agents/design.md) is the sole primary coordinator: it plans bounded work, supplies handoff context, routes and integrates assignments, and never runs tests.
- [`agent-maintainer.md`](../agents/agent-maintainer.md) exclusively owns agent-definition Markdown and root/nested `AGENTS.md` only when specifically assigned instruction ownership or maintenance. Its prompt includes the role relationships needed to perform that work inline.
- [`luna-worker.md`](../agents/luna-worker.md) implements one bounded change and may author focused tests; it returns commands unexecuted and does not independently verify.
- [`luna-scout.md`](../agents/luna-scout.md) performs targeted, read-only discovery; it does not edit or run tests.
- [`luna-reviewer.md`](../agents/luna-reviewer.md) independently audits supplied changes read-only; it does not edit or run tests.
- [`backend-tester.md`](../agents/backend-tester.md) owns backend, service, script, configuration, static, and backend end-to-end validation; it may correct tests, not product code or environment.
- [`frontend-tester.md`](../agents/frontend-tester.md) owns UI, browser, accessibility, frontend static, and end-to-end validation; it may correct tests and only exact allowlisted UI-source locator attributes, not other product or environment changes.
- [`heavy-subagent.md`](../agents/heavy-subagent.md) is an emergency replacement owner for one explicit mode after specialist failure, conflicting evidence, tightly coupled work, or explicit request. It is not a default worker, concurrent duplicate, tester, or self-certifier.

Implementation and validation ownership are distinct: once validation is assigned, the appropriate tester owns execution and test corrections without concurrent implementation-agent edits to those tests. The role descriptions explain intended responsibilities, not technical access controls.

For Markdown cleanup, [`/cleanup`](../commands/cleanup.md) routes agent-definition and assigned `AGENTS.md` instruction changes to `agent-maintainer`; it does not rely on this page for agent context.

## Research notes

OpenCode's runtime documentation defines agent discovery and scoped instruction loading; the distinction here that an ordinary Markdown link is not a loading directive applies those runtime mechanisms. Anthropic's context-engineering guidance and the AGENTS.md convention offer general context advice, not an override for runtime-specific behavior.

### Evidence and comparison

| Evidence type and source | What it supports | Assessment |
| --- | --- | --- |
| Runtime fact: OpenCode V2 agent and instruction docs (sources below) | Agent prompts, frontmatter, subagent context, and scoped instruction loading have OpenCode-defined semantics. | Use these docs—not analogies to other tools—to describe this repository's loading behavior. A normal Markdown link is not a loader. |
| Practitioner advice: [Claude Code best practices](https://code.claude.com/docs/en/best-practices) | Keep shared instructions focused on non-obvious, mistake-preventing guidance; move specialized material to on-demand skills where supported. | The “would removing this cause mistakes?” test is a useful editing heuristic, not a universal rule. Do not import Claude-specific syntax or workflow requirements. |
| Practitioner advice: [GitHub Copilot repository instructions](https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-repository-instructions) | Concrete successful commands, preconditions, and non-obvious layout can prevent recurring search or build failures. | This usefully counters minimalism as an absolute: retain evidenced prerequisites and ownership facts. Its advice to fill remaining space is not a reason to pad prompts, duplicate readily available material, or run invasive setup. Copilot loading rules are not OpenCode rules. |
| Tool-specific configuration: [Codex `AGENTS.md` configuration](https://developers.openai.com/codex/agent-configuration/agents-md) | Codex has its own override filenames, directory precedence, and size behavior. | The shared filename does not imply shared loading semantics. Do not add Codex-specific files, limits, or precedence claims to OpenCode instructions. |
| Bounded empirical evidence: [Gloaguen et al., “Evaluating AGENTS.md” (v3)](https://arxiv.org/abs/2602.11988v3) | Tests across four model/agent pairings and Python coding benchmarks found no statistically significant task-success improvement from context files overall; generated files increased average cost, while developer-written files showed a small, non-significant success change. | This is evidence against unsupported universal performance promises, not proof that useful role or repository constraints should be removed, that shorter is always better, or that this page's role map harms performance. It does not test this template's specialist prompts. |

### Qualified decisions

- Keep operational context when it prevents a plausible, recurring mistake: non-obvious ownership, boundaries, preconditions, or safe commands. Prefer concise, actionable facts over generic advice, exhaustive inventories, or duplicated reference material; use on-demand resources only where the runtime supports them.
- Resolve conflicts by checking the applicable runtime and repository authority first. Cross-tool advice is an editing perspective, not an instruction precedence rule.
- Treat instruction quality as a local engineering question. The cited study does not establish a universally optimal prompt length or causal benefit for any particular specialist wording; avoid claiming either without relevant evidence.
- This remains a human navigation and rationale page, not a required agent read. The maintainer's own prompt carries its maintenance-critical relationships inline; the repository-context benchmark is not evidence that this required role knowledge should be removed.

## Sources

- [OpenCode agents (V2)](https://opencode.ai/v2/docs/agents/)
- [OpenCode instructions (V2)](https://opencode.ai/v2/docs/instructions/)
- [Anthropic: Effective context engineering for AI agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- [AGENTS.md](https://agents.md/)
