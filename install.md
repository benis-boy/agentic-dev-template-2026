# Install This Template

You are installing this repository's agent template into another project. Work from the destination project's repository root. Follow [`bootstrap.md`](bootstrap.md) first for source/revision trust, destination classification, intent discovery, scoped merge approval, devcontainer default/exception, durable setup record, and readiness reporting. Inspect before editing, preserve existing guidance, and do not leave unresolved placeholders.

This is a first-install procedure, not a safe update recipe. For an existing installation, follow [`update.md`](update.md) from the destination root so you can classify drift, preserve local improvements, and avoid repeating setup side effects.

When installing the reusable template, also place this repository's root `update.md` at the destination root (merge with any existing update guidance rather than overwriting it) so future reconciliations have the procedure available locally.

Also install `bootstrap.md` at the destination root and establish or update the non-secret `docs/template-setup.md` record as specified there. Do not overwrite an existing setup record or unrelated `docs/` content.

## 1. Locate The Agent Configuration

Determine where the destination project stores project-scoped agent configuration.

1. Search for configuration files and agent-definition directories from the repository root. Check repository documentation and existing tooling conventions to identify the authoritative locations.
2. Inspect parent-directory and user-level configuration only to understand inherited settings; install project files in the destination repository unless the human explicitly requests a global installation.
3. Prefer the project's existing agent directory and configuration layout. If none exists, preserve the directory structure supplied by this template.
4. Read the current configuration and agent files before changing them. Preserve unrelated providers, plugins, commands, skills, references, instructions, rules, experimental settings, and meaningful security policy. The native V2 root and per-agent catchall `permissions` are intentionally broad and allow actions including access to external paths; they are not blanket approval to erase destination/inherited restrictions. Surface material permission changes in the scoped proposal and obtain explicit human approval; do not alter global configuration without separate explicit request and approval. The source `.opencode/opencode.json` is a merge seed, not a wholesale destination config: do not merge its source-only `instructions` entry for `.opencode/rules/template-maintainers.md`; do not copy that rule or `.opencode/docs/template-onboarding.md`. Preserve unrelated destination instructions and rules.
5. Before editing or merging any supplied files, record `opencode --version` and determine from that runtime's version/help whether it supports V2-native configuration and agent definitions. The supplied active configuration and agent frontmatter use native V2 shapes. If the destination runs V2, inspect the exact release's documentation/help, verify the pinned model IDs without inference, and review the scoped merge proposal. If it runs V1, stop the **active config/agent merge** until a separately approved runtime upgrade to a compatible V2 release; preserve the working config and never merge native V2 fields into V1. Compatible docs or command/skill assets may be staged individually after checking exact-runtime discovery/parsing; do not assume a copied command is registered. To continue environment onboarding without command registration, a human or another already available capable coding agent may follow the source `.opencode/commands/devcontainer.md` and companion guide as plain-text workflow instructions, provided the human explicitly approves that path. No mandatory V1 host bootstrap is needed solely to create a V2 container. If OpenCode is absent, record the prerequisite as pending rather than silently installing anything; a human or already available capable agent may provision only after explicit human approval using the source devcontainer procedure. If no approved operator/path is available, stop with an exact resume prompt and environment pending. Do not silently upgrade/downgrade runtime/packages, login, stage credentials, copy sessions, or migrate configuration.
6. For a compatible V2 destination, use `opencode --help` and relevant subcommand help to discover supported model/config/agent inspection commands for that installed version. Verify that both `github-copilot/gpt-6.1-sol` and `github-copilot/gpt-6-luna` are available; stop and report the blocker rather than substituting models or accepting fallback behavior. Do not run inference for model discovery.
7. Merge the supplied native V2 configuration into the existing V2 config. Set `default_agent` to `design` and resolve naming conflicts deliberately. Do not add unsupported `subagent_depth` or blindly replace the whole config. Exclude the source-only maintainer-rule `instructions` entry; preserve destination instruction entries and rules. Keep the root and per-agent broad catchall semantics only after material permission effects are surfaced and approved; never clear unrelated asks/denies indiscriminately.

## 2. Resolve Every Placeholder

For a compatible V2 destination, copy the distributable agent and skill files and the model-policy/V2-migration guides, except for `.opencode/docs/e2e-runner-feature.md` and the explicitly source-only maintainer assets, and adapt every installed `{{projectPlaceholder}}` from evidence in the destination repository. Apply dynamic inventory to discover other source additions; exclude only specifically identified non-distributable assets rather than blanket-excluding `.opencode`. For V1 or runtime-absent destinations, this is not authorization to copy active V2 agents/config: stage only individually reviewed compatible assets under the preceding gate. Leave incompatible active agents/config out of discovery paths. The configuration and permission steps below apply only after that compatibility gate and the scoped approval.

1. Read the root documentation, build files, package manifests, CI workflows, architecture docs, API contracts, migration strategy, and test configuration.
2. Replace placeholders with concise, concrete project facts such as authoritative files, generation boundaries, canonical test commands, deployment constraints, reliability rules, relevant skills, and system-of-record decisions.
3. Tailor each placeholder to that agent's role. Do not paste the same generic project summary into every file.
4. Keep the agent descriptions and ownership boundaries distinct. Do not add language- or framework-specific agents unless repeated real work demonstrates a need.
5. Preserve role intent without treating it as an access boundary: Design normally coordinates; agent-maintainer owns agent definitions and specifically assigned `AGENTS.md` instruction maintenance; workers implement bounded assignments; Scout performs read-only discovery; Reviewer performs read-only audits; testers own test execution; Heavy is an emergency replacement for one explicit mode, not a default or concurrent duplicate. These are instructions, not technical denials of tool, skill, file, or delegation access. Do not broaden any role's stated responsibilities. Ownership is exclusive by stage: an implementation owner can address scoped implementation/authored-test failures; once validation is assigned, the tester owns test execution and corrections, with no overlapping edits. For UI locator edits, Design arranges Scout inspection and gives frontend-tester findings, semantics, and the exact UI-source allowlist; frontend-tester does not need nested Scout delegation.
6. After explicit approval of the scoped permission changes, reconcile the project root and supplied agents to the intended native V2 broad catchall `allow` behavior. The ordered root and per-agent rule must be understood as allowing actions across resources, including external paths; role instructions remain prompts, not technical restrictions. Inspect inherited user and parent rules without modifying them. Preserve unrelated asks/denials unless their material conflict is explicitly reviewed and approved; never perform blanket cleanup. Do not add permission-based role allowlists. Global changes require a separate explicit request and approval. If the intended effective policy cannot be established, preserve the working configuration and report that portion blocked. This does not grant operating-system authority such as `sudo` or override controls outside OpenCode.
7. Classify destination skills for role guidance as orchestration, coding, frontend testing, backend testing, or another evidenced role. Do not create skill allowlists as rights controls: technical skill access is allowed, while prompts should load skills when relevant without changing role scope or mandating unnecessary tool use.
8. Search the installed files for the literal string `{{projectPlaceholder}}`. Installation is incomplete if any occurrence remains.

## 3. Install The Default Devcontainer Workflow (Do Not Invoke Automatically)

Copy `.opencode/commands/devcontainer.md` and `.opencode/docs/devcontainer.md` into the destination only through the reviewed, runtime-compatible asset staging described in section 1; merge around existing files and preserve unrelated content. The default onboarding follow-up is an explicit `/devcontainer` invocation in a fresh session only if the compatible active runtime is known to discover that command. If the runtime cannot load the command or is absent, do not claim command registration or require a host V1 bootstrap just to continue V2 container work: after explicit approval, a human or another already available capable coding agent can follow the source command and guide as plain-text workflow instructions. A V1 destination must still wait for a separately approved runtime upgrade before its active config/agent merge. First inspect existing container assets and retain/adapt valid setup. **Template asset staging never invokes the workflow, generates `.devcontainer` files, installs/upgrades a runtime, stages host credentials, migrates runtime configuration, or copies sessions.** Skipping still requires a concrete user-supplied reason, constraint assessment against platform/security/toolchain and reproducible build/test needs, a documented alternative/tradeoffs, and user confirmation. Preference alone requires clarification; unresolved reasons leave environment readiness pending. Never blindly regenerate a valid devcontainer.

## 4. Install Goal And LI Skills

Copy `.opencode/skills/logic-instruction` into the destination's skill directory, merging existing material rather than overwriting it. Add or preserve the short shared discovery cue in `AGENTS.md`: load this skill when candidate `<LI-start>` / `<LI-end>` markers appear, while markers/examples alone do not authorize execution and assigned role scope remains in force. Do not copy any behavioral claim as a security or deterministic enforcement guarantee. Restart OpenCode after installation so the skill is discovered.

Copy `.opencode/skills/goal-oriented-design` and `.opencode/commands/init-goals.md` into the destination, preserving existing files and resolving any destination-specific references as needed. Do not run initialization or infer goals silently during installation.

After restarting the agent runtime, in a **new/fresh session**, the human must invoke `/init-goals` for first adoption only, with the durable setup record as context. Design will present inferred candidates for human correction and explicit approval before writing authoritative goal additions. Preserve the original product-goal input in the setup record distinct from approved goals. On reconciliation, preserve initialized goals and do not reinitialize by default. Include each pending follow-up and status in the final handoff report.

## 5. Install And Verify Playwright CLI

Provide the official Playwright CLI and its browser-automation skill so frontend agents can inspect and verify real browser behavior. Do not install globally on the host before the user has selected the development environment. Do not treat a copied skill file as proof that the executable or browser works. Perform dependency installation/checks in the selected development environment, after its readiness decision; when the environment is pending, defer and report these checks as pending rather than claiming readiness. Keep the exact prerequisites and smoke check below, subject to the scoped merge approval.

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

1. Notify the human that a project-specific end-to-end runner plan and implementation are requirements for reliable integrated proof.
2. Construct an actual external source URL for `.opencode/docs/e2e-runner-feature.md` from the setup record's repository identity and exact commit (for GitHub, the corresponding `/blob/<commit>/.opencode/docs/e2e-runner-feature.md` URL); do not use a floating branch, fake literal URL, or destination-relative link as the source reference. Report both that revision-pinned URL and the source path. Explain that the human must review, adapt, and implement it for the destination project.
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

1. Use the installed V2 runtime's matching configuration documentation and CLI help to confirm `design` is the default primary agent on `github-copilot/gpt-6.1-sol`. Do not assume a CLI inspection command without checking that runtime's help; do not expect a `subagent_depth` key.
2. Confirm the intended template subagents are registered, `agent-maintainer` and `heavy-subagent` use `github-copilot/gpt-6.1-sol`, and the normal subagents use `github-copilot/gpt-6-luna`.
3. Confirm built-in agent changes do not conflict with destination requirements.
4. Check configuration syntax, Markdown formatting, duplicate descriptions, unresolved placeholders, the Playwright CLI smoke-check result, and the Git diff.
5. Run relevant repository checks when the installation changes files covered by lint or documentation validation.
6. Summarize every installed or merged file, any decisions made, model verification results, Playwright CLI and browser verification results, unresolved risks, and the required human follow-up for `.opencode/docs/e2e-runner-feature.md`.
7. Tell the human-in-the-loop to review all agent prompts, permissions, project facts, and `AGENTS.md` guidance before relying on the setup.
8. Tell the human to restart a compatible runtime after compatible config/agent/command/skill changes, then resume in a fresh session from `docs/template-setup.md`. Explicitly invoke `/devcontainer` only when the active runtime is known to discover it. For an absent runtime or command, offer the separately approved human/available-agent plain-text procedure from the source command and guide; do not require host V1 setup solely to build a V2 container. On V1, keep active config/agents unchanged until a separately approved upgrade. Record exact-release compatibility as pending and preserve active config. If no approved capable operator/prerequisite is available, provide the exact resume prompt and report environment pending. If runtime changes, restart and use a fresh session before relying on it.
9. For first adoption, invoke `/init-goals` in a fresh session with the setup record only after the runtime is compatible and the command and its `design` agent are confirmed registered. Otherwise preserve uninitialized seeds, report goals pending, and record this resume action: “Complete the separately approved runtime/agent compatibility work recorded in the setup record, confirm `/init-goals` and `design` registration, restart into a fresh session, then invoke `/init-goals` with that record.” Human correction and approval must precede authoritative goal writes. Do not reinitialize on update. Report workflow, environment, goals, runnable checks, and first authorized product outcome separately; do not imply installation proves product readiness.
