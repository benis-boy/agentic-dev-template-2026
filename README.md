# Agentic Development Template 2026

This repository provides a compact parent-subagent setup for software projects. It intentionally uses one primary design agent, a small set of broadly useful subagents, bounded worker-owned implementation and backend verification, exclusive frontend test execution, and a goal-oriented design workflow rather than one agent per language or framework. This source repository is the reusable template, not a destination product: it has no product-goal initialization and retains no unit-test suite.

Start with [`bootstrap.md`](bootstrap.md) from the destination repository. It establishes an exact source revision, classifies the destination as new, first adoption, or reconciliation, and routes to [`install.md`](install.md) or [`update.md`](update.md) without treating this template's own goals as product goals. Example request: “Use https://github.com/OWNER/REPO as the template source at the revision I approve, and help me create/adopt this project for: [product goal]. Preserve my work, ask about material choices, and do not scaffold the app until I approve the plan.” The agent must not clone over the destination, import source `.git`, or silently substitute a moving branch/revision.

The default onboarding path is an explicitly approved `/devcontainer` invocation after assets are installed and the agent runtime is restarted. An existing valid container may be retained or adapted after inspection; it is never blindly regenerated. Skipping requires a concrete, user-supplied reason, an assessed constraint and documented reproducible alternative, plus user confirmation. Preference alone needs clarification; unresolved reasons leave environment readiness pending. Installing assets never invokes `/devcontainer`, installs a runtime, stages credentials, migrates runtime configuration, or generates a container. `/devcontainer` is separate from approval-gated `/init-goals` and does not initialize goal documentation.

For an existing installation, use [`update.md`](update.md), not a blind recopy: it separately assesses whether reusable commands/guides are present and whether a real council or project environment is complete, current, or unknown. It also provides a behavior-based, approval-gated migration for the retired `backend-tester` role: identify template-derived definitions positively, preserve custom/repurposed agents, transfer destination-specific checks and constraints into Worker or authoritative project guidance, update only confirmed in-scope routes, and remove an obsolete definition only under reviewed destination-specific authority. Missing council/container setup is an explicit human follow-up (`/init-council <subject or ambition>` and/or `/devcontainer`) after compatible staging and command/agent availability; update never initializes either automatically. A reviewed update may include a bounded file-only repair of an existing setup, but not container operations, protected migrations, or replacement of local choices. The durable `docs/template-setup.md` record retains the evidence and independent readiness statuses.

## Design Decisions

### One Primary Coordinator

`design` is the only user-facing primary agent. It runs on `github-copilot/gpt-6.1-sol` and owns planning, routing, context-rich handoffs, and integration. It may implement a tiny fix directly only when clearly cheaper than delegation; it never runs tests.

Keeping coordination in one place avoids competing planners and fragmented ownership. The design agent receives a small, distinct menu of subagents, which makes automatic routing more reliable.

### Context-Isolated Subagents

The normal implementation, exploration, review, and frontend-test subagents run on `github-copilot/gpt-6-luna`:

- `luna-worker` implements one bounded change, authors focused tests, and owns applicable backend/service/script/config/static/backend-E2E checks plus scoped test/fix/self-review. It may also be explicitly assigned backend verification-only, without product or environment repair; a fresh non-author invocation can provide independent execution when required.
- `luna-scout` performs read-only local/upstream discovery; it never edits or runs tests.
- `luna-reviewer` independently audits a supplied change; it never edits or runs tests.
- `frontend-tester` executes UI, browser, accessibility, frontend static, and end-to-end validation; it may correct tests and make only exact-file allowlisted locator-attribute edits.
- `agent-maintainer` owns agent-definition Markdown and assigned root/nested `AGENTS.md` instruction maintenance; it is not a general documentation editor or orchestrator, and is a role-specific Sol-pinned exception.

`heavy-subagent` runs on `github-copilot/gpt-6.1-sol` and is an emergency replacement owner for exactly one explicit reconnaissance, diagnosis, implementation, or read-only review mode after a specialist fails, evidence conflicts, or a coupled task cannot safely fit one specialist. It is not a duplicate concurrent owner or self-certifier; implementation authors focused tests but does not execute them.

These roles are organized primarily by work phase and distinct evidence boundaries. Worker handles bounded implementation and backend-domain execution; frontend-tester retains exclusive UI/browser/accessibility/frontend-static/E2E execution; Reviewer remains an independent read-only audit role. A worker's own checks and self-review are not independent evidence. Once external validation takes over, edits do not overlap; environment failures stop and return to Design rather than triggering unauthorized repair. A general worker can handle application code, migrations, non-agent documentation, or infrastructure when given the right scope and project constraints. Agent definitions and assigned `AGENTS.md` instruction ownership belong to `agent-maintainer`.

### Bounded Delegation and Test Ownership

Role descriptions and prompts express intended responsibility and ownership, not enforced rights. Design normally coordinates work, and the subagent prompts preserve worker, scout, reviewer, tester, and maintainer intent. Native V2 root and agent permissions otherwise use a catchall allow, including access to paths outside the project. One explicit technical exception applies: `goal-oriented-design` is denied by default and allowed only for `design` and `heavy-subagent`; each other supplied agent repeats the deny after its catchall. Other specialists receive relevant outcomes and proof requirements inline from Design instead of loading that skill. These skill-tool permissions are not an OS-level or prompt-injection security boundary, and role and approval boundaries otherwise remain prompt instructions. Destination policies and meaningful local asks/denials still require inspection and human review; this template does not authorize blanket removal of unrelated restrictions. In this template source repository, the local-only maintainer rule additionally says **NEVER EVER load `goal-oriented-design`**, including as Design or Heavy; that rule is not distributed to destination projects.

Worker adds or updates focused tests and executes applicable backend/service/script/config/static/backend-E2E checks as part of its bounded implementation and local-check/fix/self-review loop. A verification-only worker does not repair product or environment behavior and may correct tests only when intended behavior is explicit. Ownership is exclusive by stage; once external validation is assigned, do not overlap edits. Frontend-tester alone retains UI/browser/accessibility/frontend-static/E2E execution and test corrections, plus only exact-file allowlisted locator-attribute edits. Environment/infrastructure failures stop further checking and are reported to Design; they are not repaired as a side effect of verification. For UI locator attributes, Design arranges any Scout inspection and passes findings, intended semantics, and the exact UI-source allowlist to frontend-tester. Prefer stable exact test IDs or titles, with paths only to disambiguate.

### Role Instructions Do Not Enforce Rights

Scout's read-only discovery, Reviewer's read-only audit, Worker/frontend-tester execution boundaries, and stage ownership are task instructions, not permission restrictions. Those role instructions do not themselves limit technical access to tools, skills, arbitrary files, or network resources; the explicit `goal-oriented-design` skill permission above is separate. The project is assumed to have trusted, controlled inputs and network; this template is not a prompt-injection security boundary. External operating-system, runtime, or organizational controls may still restrict actions and are outside this template's authority.

### Contextual Logic Instructions

The `logic-instruction` skill guides agents that encounter `<LI-start>` / `<LI-end>` blocks to pause at a safe boundary, check source authorization and prerequisites, carry out only bounded authorized contextual sidequests, and resume the original task with a brief separate outcome. It preserves existing authority, role, ownership, and test-execution rules; it is model guidance, not a deterministic parser, hook, permission control, or security boundary. Permissions allow tools but do not grant sidequest authority. Its scenario matrix is an acceptance specification, not executed behavioral proof; outcomes and recovery remain best effort, with no guarantee of exactly-once execution or durable recovery after context loss.

### Structured Returns

Each subagent has a role-specific Markdown return contract. Stable sections make it easier for the design agent to integrate outcomes, distinguish evidence from assumptions, and identify remaining work without imposing a brittle machine-only format.

### Living Project Context

The included `AGENTS.md` is a durable context template, not a command encyclopedia. It prioritizes product goals, system boundaries, repository invariants, canonical workflows, and cross-cutting reliability rules that should be available in every agent session.

The product-goals section explicitly requires updates alongside changes to product direction or system-of-record decisions. This keeps project context versioned and reviewable as the product evolves. The bundled `goal-oriented-design` skill adds goal trees, proof inventories, and plain-text outcome handoffs to orchestration.

## Model and Cost Policy

The supplied files pin these exact GitHub Copilot model IDs; the installer verifies availability and never silently substitutes a model or depends on fallback behavior:

- Primary, agent-maintainer, and emergency heavy subagent: `github-copilot/gpt-6.1-sol`
- Normal subagents: `github-copilot/gpt-6-luna`

Design uses Sol 6.1 for orchestration, and the emergency heavy subagent and agent-maintainer are role-specific Sol exceptions; Luna 6 is the normal subagent choice for bounded implementation, discovery, review, and frontend testing. These are qualitative role choices, not comparative benchmark claims. Account availability and model catalog change; pin the exact discovered IDs and do not use an unverified latest alias or automatic substitute.

The reusable source config and supplied agents now use native OpenCode V2 shapes. This documentation/configuration conversion does not install or upgrade OpenCode, packages, or credentials, and does not verify model calls or live runtime behavior. A V1 destination must stop before merging the V2-only active config/agent files until a separately approved runtime upgrade; never silently downgrade or overwrite its working configuration. See the [V2 migration guide](.opencode/docs/opencode-v2-migration.md) for mappings, migration caveats, and unverified acceptance gates. The historical host-version and compatibility evidence for the root devcontainer is recorded separately below and is not proof of this template migration.

## Contents

- The bundled native OpenCode V2 configuration: default-agent, ordered permissions, and built-in-agent settings.
- `.opencode/agents/design.md`: primary coordinator.
- Agent definitions for coordination, agent maintenance, implementation/backend checks, exploration, review, frontend testing, and bounded emergency work. `backend-tester` is retired; see `update.md` for safe migration of existing destination installations.
- `AGENTS.md`: project-context template.
- `.opencode/skills/playwright-cli`: official Microsoft Playwright CLI skill for browser automation. Bundled procedures are synchronized to [upstream commit `b1a5903`](https://github.com/microsoft/playwright-cli/tree/b1a5903c5b633b8c9f843ad7b629c2a78437040c/skills/playwright-cli), with local tool metadata retained. Installation also requires the matching `@playwright/cli` executable and a successful browser smoke check described in `install.md`.
- `.opencode/skills/goal-oriented-design`: reusable goal mapping, status, proof, and independent-library lifecycle workflow.
- `.opencode/skills/logic-instruction`: best-effort recognition, authorization, bounded execution, and resumption guidance for contextual LI blocks; the scenario matrix is not behavioral proof.
- `.opencode/rules/template-maintainers.md`: active source-repository-only guidance; exclude this rule and its config instruction entry when distributing the template.
- `.opencode/commands/init-goals.md`: human-triggered fresh-session initialization command; invoke `/init-goals` after restart and approve candidates before authoritative writes.
- `.opencode/commands/cleanup.md`: `/cleanup` command for scalable, type-aware Markdown review by audience, lifecycle, and canonical ownership, with honest coverage reporting.
- `.opencode/commands/devcontainer.md` and `.opencode/docs/devcontainer.md`: default explicit onboarding follow-up and operational guide for adapting a destination project to a reproducible devcontainer with OpenCode v2, host-auth staging gates, and durable sessions. Template installation only copies these files; it does not generate a devcontainer.
- `.opencode/docs/e2e-runner-feature.md`: required end-to-end runner implementation plan. The installer does not install or customize it automatically; it must notify the human to handle the plan for the destination project because reliable end-to-end proof is required for proper agentic development.
- `install.md`: agent-oriented installation procedure.
- `update.md`: destination-root workflow for behavior-based reconciliation of an existing installation, including v2 targets and local improvements.
- `bootstrap.md`: source-pinned onboarding, destination classification, approval gates, durable setup record, and readiness reporting.
- `.opencode/docs/template-onboarding.md`: one-shot maintainer review checklist and manual disposable-destination rehearsals; do not copy it into destination projects.
- `.opencode/docs/opencode-v2-migration.md`: implemented native-config mappings, compatibility guidance, and unverified runtime/model/auth acceptance gates.

## Root Devcontainer

This opt-in setup runs project tools as non-root `node` at `/workspaces/agentic-dev-template-2026`. The workspace is a host bind mount. There are no Compose services. The repository has no application manifest, CI workflow, or canonical build/lint/test/debug commands; those commands are **not established**. `.opencode/package.json` names `@opencode-ai/plugin`, but there is no evidenced consumer, so the container does not bootstrap it or change project dependencies.

Open VS Code's **Dev Containers: Reopen in Container** to create/start it. To use the Dev Container CLI:

```sh
npx -y @devcontainers/cli up --workspace-folder "$PWD" --config .devcontainer/devcontainer.json
```

Host auth staging in this generated configuration requires Bash/GNU `stat`, a host `HOME`, and a local Unix-socket Docker daemon. Other host platforms or remote daemons have not been established; the staging guard must block OpenCode rather than claim auth readiness if those prerequisites are absent.

Rebuild in VS Code with **Dev Containers: Rebuild Container**. For a CLI replacement, inspect the exact matching workspace container first, gracefully stop only that verified owner with `docker stop <verified-container-name>`, then use Dev Container CLI `up --remove-existing-container`, followed by `up` to check volume reuse. Canonical replacement/readiness and isolated approved-import session persistence have been exercised. Do not use an assumed CLI `down` subcommand.

```sh
npx -y @devcontainers/cli up --workspace-folder "$PWD" --config .devcontainer/devcontainer.json --remove-existing-container
npx -y @devcontainers/cli up --workspace-folder "$PWD" --config .devcontainer/devcontainer.json
```

The root entrypoint holds an exclusive `flock` on a root-owned lock file in the separate named volume `agentic-dev-template-2026-opencode-v2-owner-lock`, mounted at `/run/opencode-owner`. The lock directory is root-owned, group-accessible to the actual `node` group, and not writable by `node`; existing unsafe locks are never replaced. A second container sharing the owner-lock volume is rejected before state access. The separate `agentic-dev-template-2026-opencode-v2-sessions` volume contains OpenCode XDG data, state, config, cache, database/SQLite sidecars, sessions and imported credentials. Its root is `root:<node group>` mode `1770`: node can manage its own entries but cannot replace the root-owned `.owner-lock-identity` binding. This binding must match the identity in the lock volume before any database access; substituting a different lock volume is blocked rather than creating an independent owner lock. Ownership repair follows lock acquisition and is limited to data paths. Both named volumes must persist across rebuild/recreate; do not delete either or use `docker compose down -v`. Removing the data volume loses sessions and credentials; losing the owner-lock volume blocks reuse of bound data and requires separately reviewed recovery. If another container owns the lock, stop that exact old container gracefully before rebuilding; do not stop unrelated/user containers. The generated config intentionally does not name a fixed container, allowing Dev Containers to manage its normal replacement lifecycle.

The second-owner and substituted-lock rejection described above are implemented safety contracts, not exercised runtime acceptance evidence; see the verification limits below.

### Selected versions and compatibility evidence

The Dockerfile selects official Node `24.22.0-bookworm-slim`, the current supported Node LTS resolution from the [official Node release index](https://nodejs.org/dist/index.json), as observed Oct 20, 2026. OpenCode is npm [`@opencode/cli` v2.0.32](https://registry.npmjs.org/@opencode%2fcli/2.0.32), the current supported release resolution, with [source commit `843a6c514e606b436a7fe713422ace0a93ad3d61`](https://github.com/anomalyco/opencode/tree/843a6c514e606b436a7fe713422ace0a93ad3d61). These record selected versions, not enduring defaults. The image build checks the actual executable version and help. Re-resolve versions and matching compatibility evidence for an intentional refresh.

The exact-release [V1 migration guide](https://github.com/anomalyco/opencode/blob/843a6c514e606b436a7fe713422ace0a93ad3d61/services/www/src/docs/content/migrate-v1.mdx) documents continued support for project config, agents, commands, skills and existing shared files in that release; this is historical compatibility evidence, not a statement that all current `.opencode` files remain unchanged after the native V2 conversion. The release's [Credential.Entry schema](https://github.com/anomalyco/opencode/blob/843a6c514e606b436a7fe713422ace0a93ad3d61/packages/schema/src/credential.ts) and [`auth import` handler](https://github.com/anomalyco/opencode/blob/843a6c514e606b436a7fe713422ace0a93ad3d61/packages/cli/src/commands/handlers/auth/import.ts) are the supported import interface for the separately described devcontainer flow. Legacy database migration alone is not used because fresh schema creation may mark its migration applied without running the import migration. Compatibility documentation does not prove a credential is usable or that model calls work.

### Approved one-time authentication import and lifecycle

The selected mode is **explicitly approved one-time import of the single host OpenCode v1 GitHub Copilot OAuth credential**. Host v1 sessions are not copied. No-auth was not selected and is never an automatic fallback. The host `initializeCommand` stages the existing auth file from the configured `OPENCODE_AUTH_FILE`, or standard `$XDG_DATA_HOME/opencode/auth.json` / `~/.local/share/opencode/auth.json`, into a private host directory outside the repository and build context (`~/.agentic-devcontainer-auth/<devcontainerId>`, directory `0700`, file `0600`). Staging is limited to an owned regular non-symlink file and local Unix-socket Docker daemon. It tightens group/other mode bits only on that identified host file. The credential file is mounted read-only and narrowly for the container; no host home, global config or DB is mounted. After successful import, a non-secret receipt acknowledges consumption. The read-only credential staging file remains in the private host staging directory until the next host `initializeCommand`, which owns removing it; it is not deleted from the read-only container mount. Unsafe/missing auth is visibly reported but does not prevent the project container from starting; OpenCode remains blocked.

The root entrypoint obtains the lifetime lock before volume-scoped ownership repair and initialization, then drops to the `node` development user. Both its initializer and final non-root process receive `HOME=/home/node`, `USER=node`, and `LOGNAME=node`; the same values are configured for container processes, including Dev Container and Docker exec clients. This avoids retaining root's `/root` home after `setpriv` changes identity. Import reads the narrow read-only staged credential directly and copies it into private temporary storage only after fully validating the volume as fresh (allowing the protected owner-lock binding). A DB, sidecar, unknown marker, or incomplete/partial volume blocks import without reseeding or deleting it. The importer validates a single GitHub Copilot OAuth entry and converts it to the exact v2 credential import schema in private temporary storage; it invokes `opencode auth import --standalone` with output suppressed and checks a valid database and supported non-secret `opencode auth list --format json --standalone` account metadata. Under the initialization lock, a single same-filesystem rename changes the in-progress marker to the completion marker, so completed-state validation never requires an in-progress marker to be absent before it is removed. It then validates completed state, account metadata, and the normal `opencode auth list --format json` launcher before acknowledging success with a non-secret cleanup receipt. The read-only mounted auth file is not deleted by the container. The next host `initializeCommand` removes its private staged copy and leaves the receipt in place, preventing restaging on rebuild. Plain `opencode` is guarded by this initializer; the root entrypoint attempts initialization on startup while leaving the project shell usable when blocked. `opencode-container-auth status` reports non-secret readiness. The account metadata check is not proof of token validity or model access. Later host auth changes are not synchronized; refreshing imported auth or recovering partial state is not automated.

Optional locally trusted public CA certificates can be placed directly in `.devcontainer/certs/` as `.crt` files. Git ignores that directory's local contents, while the root `.dockerignore` separately limits build-context input from it to direct `.crt` files and the harmless placeholder; other files are excluded from the image build. A clean checkout therefore does not require developer-specific certificates. The build copies any supplied public certificates into the trust stage before assembling the CA bundle and into the runtime image before regenerating its system store. With no local certificates, the normal base-image/system public trust path remains in use. Docker must already be able to pull the public base images using its own host/daemon trust. TLS verification remains enabled. Put only public `.crt` certificates in this directory; never put private keys or credentials there.

For backup, stop the exact owner container first. Store a restricted archive outside the checkout and never merge it into active state. Example for a local Docker daemon:

```sh
install -d -m 700 "$HOME/private-opencode-backups"
umask 077
docker run --rm -v agentic-dev-template-2026-opencode-v2-sessions:/data:ro node:24.22.0-bookworm-slim tar -C /data -czf - . > "$HOME/private-opencode-backups/opencode-v2.tar.gz"
```

Restore only to an intentionally selected empty volume while no container owns it, retaining the original owner-lock volume matching the archived `.owner-lock-identity` and substituting the archive path as needed. A missing or mismatched lock volume blocks startup; do not remove the binding as a workaround:

```sh
docker run --rm -v agentic-dev-template-2026-opencode-v2-sessions:/data -v "$HOME/private-opencode-backups":/backup:ro node:24.22.0-bookworm-slim tar -C /data -xzf /backup/opencode-v2.tar.gz
```

On the next container start, the volume-scoped entrypoint restores ownership for the configured non-root `node` account.

Credentials staged by the host may remain in the private directory until the next host initialization/cleanup flow; keep them out of source control and ordinary logs. Do not reopen failed validation volumes or reseed existing state automatically. To start, use **Dev Containers: Reopen in Container** or the CLI `up` command above. To rebuild in VS Code, use **Dev Containers: Rebuild Container**; for CLI replacement, inspect and gracefully stop only the exact verified owner before the `up --remove-existing-container` command above, then run the regular `up` to confirm reuse. Preserve both named volumes. For backup and restore, follow the restricted archive steps above and retain the matching owner-lock volume; never merge an archive into active state.

Verification limits: paid inference/token validity and native VS Code behavior were not verified. Second-owner rejection, substituted-lock behavior, concurrent initialization, and the broader adverse-state matrix were not exercised. Previously reported static shell, JSON/config, and diff checks do not establish those untested behaviors and were not rerun for this publication-hygiene change. This repository has no established app build/lint/test commands. No tests or fixtures are retained. The existing goal-oriented-design seed references remain pristine.
