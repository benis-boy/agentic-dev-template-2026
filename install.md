# Install This Template

You are installing this repository's agent template into another project. Work from the destination project's repository root. Inspect before editing, preserve existing guidance, and do not leave unresolved placeholders.

This is a first-install procedure, not a safe update recipe. For an existing installation, follow [`update.md`](update.md) from the destination root so you can classify drift, preserve local improvements, and avoid repeating setup side effects.

When installing the reusable template, also place this repository's root `update.md` at the destination root (merge with any existing update guidance rather than overwriting it) so future reconciliations have the procedure available locally.

## 1. Locate The Agent Configuration

Determine where the destination project stores project-scoped agent configuration.

1. Search for configuration files and agent-definition directories from the repository root. Check repository documentation and existing tooling conventions to identify the authoritative locations.
2. Inspect parent-directory and user-level configuration only to understand inherited settings; install project files in the destination repository unless the human explicitly requests a global installation.
3. Prefer the project's existing agent directory and configuration layout. If none exists, preserve the directory structure supplied by this template.
4. Read the current configuration and agent files before changing them. Preserve unrelated providers, plugins, commands, skills, references, and experimental settings. This template explicitly authorizes changing relevant OpenCode permission rules to remove tool approval prompts and restrictions; do not preserve inherited or local `ask`/`deny` rules that conflict with this policy.
5. Before editing or merging any supplied files, record `opencode --version` and determine from that runtime's version/help whether it is v1 or v2. The supplied active configuration and agent frontmatter are v1 only. If the destination runs v2, stop this standard installation before making changes and direct the human to `.opencode/docs/opencode-v2-migration.md` for a separately approved staging migration. Never merge v1 fields into a v2 runtime or silently upgrade/downgrade the destination runtime or packages.
6. For a v1 destination, use `opencode --help` and relevant subcommand help to discover supported model/config/agent inspection commands for that installed version. Only then use its model-discovery mechanism to verify that both `github-copilot/gpt-6.1-sol` and `github-copilot/gpt-6-luna` are available. Stop and report the blocker rather than substituting models or accepting fallback behavior. Do not run inference for model discovery.
7. Merge the supplied v1 configuration into the existing v1 config. Set `default_agent` to `design` and resolve naming conflicts deliberately. Do not add unsupported `subagent_depth` or blindly replace the whole config.

## 2. Resolve Every Placeholder

Copy the supplied agent and skill files and the model-policy/v2-migration guides, except for `.opencode/docs/e2e-runner-feature.md`, and adapt every installed `{{projectPlaceholder}}` from evidence in the destination repository.

1. Read the root documentation, build files, package manifests, CI workflows, architecture docs, API contracts, migration strategy, and test configuration.
2. Replace placeholders with concise, concrete project facts such as authoritative files, generation boundaries, canonical test commands, deployment constraints, reliability rules, relevant skills, and system-of-record decisions.
3. Tailor each placeholder to that agent's role. Do not paste the same generic project summary into every file.
4. Keep the agent descriptions and ownership boundaries distinct. Do not add language- or framework-specific agents unless repeated real work demonstrates a need.
5. Preserve role intent without treating it as an access boundary: Design normally coordinates; workers implement bounded assignments; Scout performs read-only discovery; Reviewer performs read-only audits; testers own test execution; Heavy is an emergency replacement for one explicit mode, not a default or concurrent duplicate. These are instructions, not technical denials of tool, skill, file, or delegation access. Do not broaden any role's stated responsibilities. Ownership is exclusive by stage: an implementation owner can address scoped implementation/authored-test failures; once validation is assigned, the tester owns test execution and corrections, with no overlapping edits. For UI locator edits, Design arranges Scout inspection and gives frontend-tester findings, semantics, and the exact UI-source allowlist; frontend-tester does not need nested Scout delegation.
6. Set the active root OpenCode permission to `allow` and set `permission: allow` in each of the seven supplied agent frontmatters. Remove conflicting permission maps, inherited/local OpenCode `ask`/`deny` rules, and permission-based tool/skill/delegation allowlists from the resolved OpenCode configuration so no OpenCode tool approval prompts or runtime rights restrictions remain for these agents. Inspect the resolved configuration/rules, including inherited user and parent settings; report any external policy that still restricts actions rather than promising this template can bypass it. This does not grant operating-system authority such as `sudo`, nor does it override controls outside OpenCode.
7. Classify destination skills for role guidance as orchestration, coding, frontend testing, backend testing, or another evidenced role. Do not create skill allowlists as rights controls: technical skill access is allowed, while prompts should load skills when relevant without changing role scope or mandating unnecessary tool use.
8. Search the installed files for the literal string `{{projectPlaceholder}}`. Installation is incomplete if any occurrence remains.

## 3. Install The Optional Devcontainer Command

Copy `.opencode/commands/devcontainer.md` and `.opencode/docs/devcontainer.md` into the destination, merging around existing files and preserving unrelated command/documentation content. These files provide a human-triggered reusable workflow; **do not invoke `/devcontainer`, generate `.devcontainer` files, install OpenCode v2, stage host credentials, or migrate runtime configuration during template installation**. The standard installer's existing v1/v2 compatibility gate remains in force. After installation, the human may explicitly invoke `/devcontainer` from a destination project when they want that project adapted; it asks before assuming an empty/ambiguous stack and reports auth blockers rather than logging in.

## 4. Install Goal Documentation Workflow

Copy `.opencode/skills/goal-oriented-design` and `.opencode/commands/init-goals.md` into the destination, preserving existing files and resolving any destination-specific references as needed. Do not run initialization or infer goals silently during installation.

After restarting the agent runtime, in a **new/fresh session**, the human must invoke `/init-goals`. Design will present inferred candidates for human correction and explicit approval before writing authoritative goal additions. Installation remains incomplete for goal-driven use until the goal tree, proof inventory, and index are seeded and reviewed. Include this required follow-up in the final handoff report.

## 5. Install And Verify Playwright CLI

Install the official Playwright CLI and its browser-automation skill so frontend agents can inspect and verify real browser behavior. Do not treat the presence of a copied skill file as proof that the executable or browser works.

1. Confirm Node.js 18 or newer is available with `node --version`. Stop and report the blocker if it is not.
2. Install the current official CLI with `npm install -g @playwright/cli@latest`.
3. From the destination repository root, run `playwright-cli install --skills=agents`, then move the installed `.agents/skills/playwright-cli` directory to `.opencode/skills/playwright-cli` and remove the empty `.agents` directories. The CLI does not currently offer an opencode installation target, while this template standardizes project skills under `.opencode/skills`.
4. Install Chromium and its required host dependencies with `playwright-cli install-browser chromium --with-deps`. If elevated operating-system permission is required, ask the human to authorize or perform this step; OpenCode's allow permission does not grant `sudo` or override OS authority. Do not claim browser support is ready when dependency installation fails.
5. Confirm command discovery with `playwright-cli --version` and `playwright-cli --help`.
6. Perform a real browser smoke check with a disposable named session:

   ```bash
   playwright-cli -s=install-check open "data:text/html,<title>playwright-cli-ready</title><h1>ready</h1>"
   playwright-cli -s=install-check --raw eval "document.title"
   playwright-cli -s=install-check close
   ```

   The evaluation must print `playwright-cli-ready`, and the close command must succeed. On failure, preserve the error, attempt `playwright-cli -s=install-check close` only for cleanup, and report installation as blocked rather than weakening the check.
7. Confirm `.opencode/skills/playwright-cli/SKILL.md` exists. Restart opencode after installation so the newly installed skill is discovered.

## 6. Require A Project End-to-End Runner Plan

Do not copy, merge, customize, or resolve placeholders in `.opencode/docs/e2e-runner-feature.md` during template installation. It is a reference implementation plan that requires deliberate product, platform, and test-infrastructure decisions by the destination project's human maintainers.

1. Notify the human that a project-specific end-to-end runner plan and implementation are requirements for proper agentic development and reliable integrated proof.
2. Point the human to this template's `.opencode/docs/e2e-runner-feature.md` and explain that they must review, adapt, and implement it for the destination project.
3. Report this as a required follow-up, not as an installed file, unresolved installation placeholder, or optional suggestion.
4. Do not claim installation provides end-to-end readiness merely because the reference plan exists in this template.

## 7. Merge AGENTS.md Carefully

Treat the destination's existing `AGENTS.md` as user-owned project context.

1. If no `AGENTS.md` exists, start from this template and fill every placeholder.
2. If one exists, merge concepts rather than replacing the file. Preserve accurate project-specific requirements and remove only clear duplication or stale details supported by repository evidence.
3. Put durable, universally useful context in `AGENTS.md`: product goals, capability boundaries, systems of record, repository invariants, authoritative files, canonical workflows, generated-code rules, and cross-cutting reliability constraints.
4. Move or omit volatile command examples, exhaustive port lists, transient troubleshooting notes, and narrow component instructions that do not belong in every agent session.
5. Add the living-summary rule: product goals must be updated in the same change when product direction, capability boundaries, or system-of-record decisions evolve.
6. Keep detailed architecture and operations documentation in their dedicated files, and link to those files from `AGENTS.md` when every agent needs to know they are authoritative.

## 8. Validate And Hand Off

1. Use the installed runtime's matching configuration/schema and CLI help to confirm `design` is the default primary agent on `github-copilot/gpt-6.1-sol`. Do not assume a CLI inspection command without checking that runtime's help; do not expect a `subagent_depth` key.
2. Confirm the intended template subagents are registered, the normal subagents use `github-copilot/gpt-6-luna`, and `heavy-subagent` uses `github-copilot/gpt-6.1-sol`.
3. Confirm built-in agent changes do not conflict with destination requirements.
4. Check configuration syntax, Markdown formatting, duplicate descriptions, unresolved placeholders, the Playwright CLI smoke-check result, and the Git diff.
5. Run relevant repository checks when the installation changes files covered by lint or documentation validation.
6. Summarize every installed or merged file, any decisions made, model verification results, Playwright CLI and browser verification results, unresolved risks, and the required human follow-up for `.opencode/docs/e2e-runner-feature.md`.
7. Tell the human-in-the-loop to review all agent prompts, permissions, project facts, and `AGENTS.md` guidance before relying on the setup.
8. Tell the human to restart the agent runtime because configuration and agent files are loaded at startup, then start a fresh session and invoke `/init-goals`.
9. Report that human correction and approval must precede authoritative goal writes, and that goal-driven installation is incomplete until initialization is completed.
