# Agentic Development Template 2026

This repository provides a compact parent-subagent setup for software projects. It intentionally uses one primary design agent, a small set of broadly useful subagents, dedicated frontend and backend test executors, and a goal-oriented design workflow rather than one agent per language or framework. This source repository is the reusable template, not a destination product: it has no product-goal initialization and retains no unit-test suite.

Start with [`bootstrap.md`](bootstrap.md) from the destination repository. It establishes an exact source revision, classifies the destination as new, first adoption, or reconciliation, and routes to [`install.md`](install.md) or [`update.md`](update.md) without treating this template's own goals as product goals. Example request: “Use https://github.com/OWNER/REPO as the template source at the revision I approve, and help me create/adopt this project for: [product goal]. Preserve my work, ask about material choices, and do not scaffold the app until I approve the plan.” The agent must not clone over the destination, import source `.git`, or silently substitute a moving branch/revision.

The default onboarding path is an explicitly approved `/devcontainer` invocation after assets are installed and the agent runtime is restarted. An existing valid container may be retained or adapted after inspection; it is never blindly regenerated. Skipping requires a concrete, user-supplied reason, an assessed constraint and documented reproducible alternative, plus user confirmation. Preference alone needs clarification; unresolved reasons leave environment readiness pending. Installing assets never invokes `/devcontainer`, installs a runtime, stages credentials, migrates runtime configuration, or generates a container. `/devcontainer` is separate from approval-gated `/init-goals` and does not initialize goal documentation.

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

### Contextual Logic Instructions

The `logic-instruction` skill guides agents that encounter `<LI-start>` / `<LI-end>` blocks to pause at a safe boundary, check source authorization and prerequisites, carry out only bounded authorized contextual sidequests, and resume the original task with a brief separate outcome. It preserves existing authority, role, ownership, and test-execution rules; it is model guidance, not a deterministic parser, hook, permission control, or security boundary. Permissions allow tools but do not grant sidequest authority. Its scenario matrix is an acceptance specification, not executed behavioral proof; outcomes and recovery remain best effort, with no guarantee of exactly-once execution or durable recovery after context loss.

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

This checkout is known to have OpenCode `1.18.35`. The reported latest stable release on 2026-10-19 is `1.19.3` (Oct 16); v2 docs/distribution are a separate channel. This template does not upgrade runtime, packages, or credentials. See the [v2 migration readiness guide](.opencode/docs/opencode-v2-migration.md); its staging path is planned, not verified runtime support. The standard first install keeps its v1 compatibility gate. Existing v2 destinations require separately approved, release-specific compatibility work; do not automatically downgrade or overwrite working configuration.

## Contents

- The bundled v1 runtime configuration: default-agent and built-in-agent settings.
- `.opencode/agents/design.md`: primary coordinator.
- Agent definitions for implementation, exploration, review, frontend testing, backend testing, and bounded emergency work.
- `AGENTS.md`: project-context template.
- `.opencode/skills/playwright-cli`: official Microsoft Playwright CLI skill for browser automation. Installation also requires the matching `@playwright/cli` executable and a successful browser smoke check described in `install.md`.
- `.opencode/skills/goal-oriented-design`: reusable goal mapping, status, proof, and independent-library lifecycle workflow.
- `.opencode/skills/logic-instruction`: best-effort recognition, authorization, bounded execution, and resumption guidance for contextual LI blocks; the scenario matrix is not behavioral proof.
- `.opencode/rules/template-maintainers.md`: active source-repository-only guidance; exclude this rule and its config instruction entry when distributing the template.
- `.opencode/commands/init-goals.md`: human-triggered fresh-session initialization command; invoke `/init-goals` after restart and approve candidates before authoritative writes.
- `.opencode/commands/devcontainer.md` and `.opencode/docs/devcontainer.md`: default explicit onboarding follow-up and operational guide for adapting a destination project to a reproducible devcontainer with OpenCode v2, host-auth staging gates, and durable sessions. Template installation only copies these files; it does not generate a devcontainer.
- `.opencode/docs/e2e-runner-feature.md`: required end-to-end runner implementation plan. The installer does not install or customize it automatically; it must notify the human to handle the plan for the destination project because reliable end-to-end proof is required for proper agentic development.
- `install.md`: agent-oriented installation procedure.
- `update.md`: destination-root workflow for behavior-based reconciliation of an existing installation, including v2 targets and local improvements.
- `bootstrap.md`: source-pinned onboarding, destination classification, approval gates, durable setup record, and readiness reporting.
- `.opencode/docs/template-onboarding.md`: one-shot maintainer review checklist and manual disposable-destination rehearsals; do not copy it into destination projects.
- `.opencode/docs/model-policy.md`: model pins, dated Copilot pricing context, and cost policy.
- `.opencode/docs/opencode-v2-migration.md`: separate staging plan and unverified migration gates.

## Root Devcontainer

This checkout includes an opt-in, project-root development container. Open it with VS Code's **Dev Containers: Reopen in Container** command, or start it with the Dev Container CLI:

```sh
npx -y @devcontainers/cli up --workspace-folder "$PWD" --config .devcontainer/devcontainer.json
```

Rebuild/recreate it from VS Code with **Dev Containers: Rebuild Container**. Reopening/rebuilding preserves the named `agentic-dev-template-2026-opencode-v2-sessions` volume; do not delete it or use `docker compose down -v`. The workspace is bind-mounted at `/workspaces/agentic-dev-template-2026`, and development processes run as non-root `node`; the root container entrypoint acquires the volume-wide owner lock, initializes ownership within that volume only, then drops to `node`. There are no Compose services. The image contains Git, CA certificates, Node/npm, and OpenCode only: this repository has no app build, lint, test, browser, or debug dependency evidence requiring additional tooling, so no application build/lint/test command is prescribed. `.opencode/package.json` names `@opencode-ai/plugin` 1.18.35, but repository inspection found no plugin consumer; the image does not bootstrap it or alter package manifests/locks. Existing named volumes are preserved and never automatically deleted, overwritten, or reseeded; an old or partial volume may remain blocked and needs explicit recovery rather than cleanup by this workflow.

### Selected versions and compatibility evidence

The image uses the maintained Node `lts-bookworm-slim` Docker tag (Node LTS release selected from the [official Node release index](https://nodejs.org/dist/index.json): `24.22.0`; selection recorded Oct 19, 2026, not an enduring pin). OpenCode uses npm [`@opencode/cli` v2.0.32](https://registry.npmjs.org/@opencode%2fcli/2.0.32), the latest supported release in the verified source set on Oct 19, 2026; the npm package metadata identifies its [source commit](https://github.com/anomalyco/opencode/tree/843a6c514e606b436a7fe713422ace0a93ad3d61). The Docker build checks the installed CLI is that v2 version and writes the selected version, actual Node version, and build date to `/usr/local/libexec/opencode-v2/build-metadata.txt` inside the image. These version strings document this generated resolution; re-resolve the latest supported Node LTS and v2 release and matching compatibility evidence when intentionally refreshing the image.

OpenCode's [v2 migration guide at that exact source commit](https://github.com/anomalyco/opencode/blob/843a6c514e606b436a7fe713422ace0a93ad3d61/services/www/src/docs/content/migrate-v1.mdx) says existing supported v1 config, agent definitions, commands, skills, and `.opencode` files remain supported without rewriting. The matching [legacy credential migration](https://github.com/anomalyco/opencode/blob/843a6c514e606b436a7fe713422ace0a93ad3d61/packages/core/src/database/migration/20260805200742_import_legacy_credentials.ts) maps GitHub Copilot OAuth to the `device` method, but database initialization can record the migration as applied without executing its `up` function when it first creates the database schema. Therefore, simply copying legacy `auth.json` before first DB use is not a reliable importer. The [v2 `auth import` handler](https://github.com/anomalyco/opencode/blob/843a6c514e606b436a7fe713422ace0a93ad3d61/packages/cli/src/commands/handlers/auth/import.ts) accepts stdin containing an array validated by the exact-release [credential-entry schema](https://github.com/anomalyco/opencode/blob/843a6c514e606b436a7fe713422ace0a93ad3d61/packages/schema/src/credential.ts); that is the explicitly invoked import path used below. The project `.opencode` files and agents are preserved unchanged. Source compatibility evidence is not proof of successful credential import, token usability, or model behavior.

### Authentication and durable sessions

One dedicated named volume stores all OpenCode XDG data, state, configuration, and cache under `/home/node/.opencode-v2`; that includes its SQLite database and sidecars, state and service metadata, and any sessions/credentials. The entrypoint obtains an exclusive lifetime `flock` on the volume before ownership setup, rejecting a second container before it can open the database; normal CLI clients within the owner container use OpenCode's managed shared service. Ownership setup does not follow symlinks or cross filesystems. The workspace remains a host bind mount.

The Dev Container records the selected `legacy-import-approved` mode in configuration. VS Code's native `initializeCommand` prepares a private host-only staging directory before its narrow bind mount is established; lifecycle hooks then securely copy the staged file into container-private storage and import it under the persistent initialization lock before ordinary `opencode` can open its database. On an already initialized volume, lifecycle validates its marker/database and runs the supported `opencode auth list --format json` check before reporting readiness. Legacy-imported state must still report the recorded GitHub Copilot credential in non-secret account metadata; fresh-no-auth state only requires a successful valid auth-list response and may later contain accounts. A failed check preserves state and blocks readiness without reseeding or removing the marker. Plain `opencode` is ready after the lifecycle succeeds. Ordinary project files remain usable if auth preparation cannot proceed, but OpenCode stays blocked with a visible error; no-auth is never silently selected. Exact standalone version/help commands run with disposable XDG roots, cleaned after use; documented `debug paths {db,data,state,config,cache}` commands return the corresponding persistent paths without invoking OpenCode or touching the volume. Other help/path argument combinations do not receive the pre-initialization exception. The underlying binary at `/opt/opencode/bin/opencode` is an implementation detail; invoking it directly bypasses the wrapper and is unsupported.

#### Corporate TLS trust

The image includes the two public corporate CA certificates explicitly approved for this development environment: Koerber Root CA (SHA-256 fingerprint `EE:2F:05:1E:33:8C:DD:5C:E7:EB:C1:42:44:A1:B6:CF:1C:5E:65:02:EF:64:62:30:0A:6D:22:B3:EA:00:E5:ED`) and WERUM Global CA (`00:9B:39:2E:B3:16:80:D6:9F:B7:C9:CB:85:D0:8C:EB:20:84:68:58:4A:03:B5:61:BA:FF:B3:39:7C:3F:07:AE`). The PEMs are sourced from the approved working project example and are added alongside (not instead of) the base image's public trust roots. `update-ca-certificates` makes them available to system TLS clients; Node/npm and OpenCode additionally receive their combined bundle through `NODE_EXTRA_CA_CERTS`, including during the image's npm install. This is corporate-network-specific trust: removing or replacing these certificates may again prevent access through that network's TLS inspection, while retaining them extends trust to certificates issued under those roots. The image contains public CA certificates only; it does not copy developer credentials, private keys, or TLS-bypass settings. Earlier acceptance reported an authorized HTTP 200 request to `https://models.opencode.ai/api.json`; this change still requires lifecycle/import acceptance against a disposable volume.

The selected mode explicitly approves import of the host's existing OpenCode v1 legacy auth file. `initializeCommand` searches the optional `OPENCODE_LEGACY_AUTH_FILE` path or the standard XDG/OpenCode auth location without displaying its contents. It only removes group/other permissions from an owned regular file; symlinks, unsafe parents, other-owner files, non-local Docker daemons, and unavailable sources are rejected or left unstaged. The staged copy is mode `0600`. The project-local repository, image build context, build arguments, and logs never receive credential contents. A private `0700` host directory outside the checkout is narrowly mounted; container root copies any staged file into a `0700` container-private directory and removes the host staging copy before dropping to non-root `node`.

Before any database-opening import, the lifecycle initializer validates the staged legacy object and converts only the explicitly approved single `github-copilot` OAuth entry into the exact v2 `Credential.Entry` shape. It maps the legacy OAuth fields to `methodID: device`, `integrationID: github-copilot`, an OAuth label, and a stable private credential ID; optional `accountId` and `enterpriseUrl` become supported metadata fields. Unexpected providers/keys or invalid required fields block initialization rather than silently dropping data. The transformed JSON exists only in mode-`0600` private runtime storage, is piped to `/opt/opencode/bin/opencode auth import --standalone`, and is removed after success or failure; command errors and import output are suppressed so credential values are not logged. The initialization lock is held throughout; only a successful import followed by account-list verification and database validation writes the completion marker. Failures preserve partial state and block automatic retries. Pre-initialization may create an XDG cache tree before the hook runs; freshness permits only a nonsymlink `xdg/cache` tree containing regular files/directories alongside the initialization lock files. It does not inspect, change, or remove cache contents, and still rejects any database, sidecar, credential file, marker, initialization marker, other XDG subtree, symlink, or special file. This accommodates unrelated editor/tool cache creation without treating cache presence as proof of database initialization. This confirms non-secret GitHub Copilot account metadata, not token usability or inference. Missing credentials do not select no-auth: ordinary non-OpenCode development continues, while OpenCode clearly remains blocked.

For deliberate recovery only, `.devcontainer/scripts/stage-legacy-auth.sh` can still explicitly stage to a running container. The separate `opencode-container-auth initialize-fresh-no-auth` command is an explicit opt-in for a completely fresh volume only; it is not an automatic fallback. Once database, sidecar, marker, or partial state exists, neither mode overwrites/reseeds it. Preserve sessions and use OpenCode's account interface for later account changes rather than another legacy import.

Treat the named volume as private credential/session data. Back up only while the container/service is stopped, and store archives outside the repository with host-only access. Example using a private host directory and Docker's local daemon:

```sh
install -d -m 700 "$HOME/private-opencode-backups"
umask 077
docker run --rm -v agentic-dev-template-2026-opencode-v2-sessions:/data:ro node:lts-bookworm-slim tar -C /data -czf - . > "$HOME/private-opencode-backups/opencode-v2.tar.gz"
```

Restore only into a deliberately selected, empty volume while no container uses it; substitute the volume and archive paths as appropriate. This extracts the complete saved state and repairs ownership for UID/GID 1000:

```sh
docker run --rm -v agentic-dev-template-2026-opencode-v2-sessions:/data -v "$HOME/private-opencode-backups":/backup:ro node:lts-bookworm-slim sh -c 'tar -C /data -xzf /backup/opencode-v2.tar.gz && chown -R 1000:1000 /data'
```

Never merge a backup over active state. Removing the volume permanently removes its sessions and imported credentials. Do not use Docker volume deletion as ordinary cleanup. No backup or restore has been executed.

**Earlier acceptance evidence (Oct 19, 2026):** backend-tester built and started the then-current image with Dev Container CLI 0.89.0, using a 1,200-second timeout. It reported CLI configuration parsing, non-root workspace access, exact OpenCode v2.0.32 version/help, metadata isolation, pre-initialization blocking, and rejection of a second container sharing an acceptance volume. This earlier evidence predates automatic host staging and lifecycle import; the new lifecycle and real credential import require fresh validation.

**Corporate TLS acceptance (Oct 19, 2026):** an earlier tester reported an HTTPS request to `https://models.opencode.ai/api.json` returning HTTP 200 with TLS authorization enabled, and a fresh no-auth initialization on a separate acceptance volume. TLS verification remains enabled. This did not initialize the configured sessions volume or stage credentials.

**Automatic lifecycle acceptance (Oct 20, 2026):** backend-tester exercised the actual Dev Container CLI create/start hooks with the approved host credential, then recreated an isolated acceptance container using the same volume. Explicit GitHub Copilot import and subsequent readiness checks passed; the database inode/size and account metadata were preserved across recreation. After the cache-only freshness correction, the canonical project configuration also completed automatic initialization on its existing `agentic-dev-template-2026-opencode-v2-sessions` volume. Container `500c66f0763e0c53b4cf1e3cfdcc1845410bfbdea23901d3b4b4ca49dce5b27b` was left running for development. Supported metadata reported one GitHub Copilot credential connection; non-root Node v24.22.0 and OpenCode v2.0.32 checks passed. The catalog request returned HTTP 200 with TLS authorization enabled, and host/container temporary credential copies were absent. Shell syntax, JSON parsing, and `git diff --check` passed. This supersedes the pending lifecycle-validation statements above.

Acceptance-only volumes—including failed attempts retained without recovery or deletion and the successful credential-bearing isolated acceptance volume—remain private data under the host operator's cleanup responsibility. Validation-owned acceptance containers were stopped; no volume was deleted. Token usability, actual agent/model inference, native VS Code UI behavior beyond the exercised shared lifecycle configuration, and session-ID persistence remain unverified. No login or inference was performed. No unit-test files were added; the goal references remain unchanged template seeds.
