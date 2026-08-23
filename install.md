# Install This Template

You are installing this repository's agent template into another project. Work from the destination project's repository root. Inspect before editing, preserve existing guidance, and do not leave unresolved placeholders.

## 1. Locate The Agent Configuration

Determine where the destination project stores project-scoped agent configuration.

1. Search for configuration files and agent-definition directories from the repository root. Check repository documentation and existing tooling conventions to identify the authoritative locations.
2. Inspect parent-directory and user-level configuration only to understand inherited settings; install project files in the destination repository unless the human explicitly requests a global installation.
3. Prefer the project's existing agent directory and configuration layout. If none exists, preserve the directory structure supplied by this template.
4. Read the current configuration and agent files before changing them. Preserve unrelated providers, plugins, permissions, commands, skills, references, and experimental settings.
5. Use the runtime's model-discovery mechanism to verify that both `github-copilot/gpt-5.6-sol` and `github-copilot/gpt-5.6-luna` are available. Stop and report the blocker rather than substituting models or accepting fallback behavior.
6. Merge the supplied configuration into the existing config. Set `default_agent` to `design`, set `subagent_depth` to `1`, and resolve naming conflicts deliberately. Do not blindly replace the whole config.

## 2. Resolve Every Placeholder

Copy the five agent files and adapt every `{{projectPlaceholder}}` from evidence in the destination repository.

1. Read the root documentation, build files, package manifests, CI workflows, architecture docs, API contracts, migration strategy, and test configuration.
2. Replace placeholders with concise, concrete project facts such as authoritative files, generation boundaries, canonical test commands, deployment constraints, reliability rules, relevant skills, and system-of-record decisions.
3. Tailor each placeholder to that agent's role. Do not paste the same generic project summary into every file.
4. Keep the four descriptions distinct: implementation, exploration, review, and validation. Do not add language-specific agents unless repeated real work demonstrates a need.
5. Search the installed files for the literal string `{{projectPlaceholder}}`. Installation is incomplete if any occurrence remains.

## 3. Merge AGENTS.md Carefully

Treat the destination's existing `AGENTS.md` as user-owned project context.

1. If no `AGENTS.md` exists, start from this template and fill every placeholder.
2. If one exists, merge concepts rather than replacing the file. Preserve accurate project-specific requirements and remove only clear duplication or stale details supported by repository evidence.
3. Put durable, universally useful context in `AGENTS.md`: product goals, capability boundaries, systems of record, repository invariants, authoritative files, canonical workflows, generated-code rules, and cross-cutting reliability constraints.
4. Move or omit volatile command examples, exhaustive port lists, transient troubleshooting notes, and narrow component instructions that do not belong in every agent session.
5. Add the living-summary rule: product goals must be updated in the same change when product direction, capability boundaries, or system-of-record decisions evolve.
6. Keep detailed architecture and operations documentation in their dedicated files, and link to those files from `AGENTS.md` when every agent needs to know they are authoritative.

## 4. Validate And Hand Off

1. Use the runtime's configuration-inspection mechanism from the destination repository and confirm `design` is the default primary agent on `github-copilot/gpt-5.6-sol`.
2. Confirm exactly the intended four template subagents are registered and each uses `github-copilot/gpt-5.6-luna`.
3. Confirm built-in agent changes do not conflict with destination requirements.
4. Check configuration syntax, Markdown formatting, duplicate descriptions, unresolved placeholders, and the Git diff.
5. Run relevant repository checks when the installation changes files covered by lint or documentation validation.
6. Summarize every installed or merged file, any decisions made, model verification results, and any unresolved risks.
7. Tell the human-in-the-loop to review all agent prompts, permissions, project facts, and `AGENTS.md` guidance before relying on the setup.
8. Tell the human to restart the agent runtime because configuration and agent files are loaded at startup.
