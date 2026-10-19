# OpenCode v2 Migration Readiness

**Status: planning only; v2 compatibility and authentication migration have not been tested.** The active template remains a v1 configuration. Do not upgrade the runtime, packages, account credentials, or active agent files as part of template installation. The installed runtime observed for this template is `1.18.35`. The reported latest stable release on 2026-10-19 is `1.19.3` (Oct 16); v2 documentation and distribution are a separate channel. Check the [latest stable release](https://github.com/anomalyco/opencode/releases/latest) and [v2 docs](https://opencode.ai/v2/docs/) independently before planning a migration.

This guide is a staging checklist, not a claim of supported or verified v2 behavior. Keep any candidate v2 files in a separate, deliberately undiscoverable staging target or branch. Never place v2 agent definitions in the active `.opencode/agents` directory while using a v1 runtime.

## 1. Freeze and stage safely

1. Record the current runtime version and preserve the current working v1 configuration and agent prompts in version control. Do not change pinned model IDs, package versions, or credentials as a side effect.
2. Back up OpenCode user data securely **outside the repository** before first launch of a candidate v2 runtime. Restrict access and retention; never dump tokens, copy credentials into notes, or commit a backup. Do not assume a particular auth database filename or database layout.
3. Create a separate migration branch/profile and stage converted files outside discoverable active agent directories. Use the documentation and schema that match the exact candidate runtime; schemas and docs can drift independently.
4. Find supported commands from that runtime's CLI help. Do not assume v1 diagnostic commands exist in v2.

## 2. Convert agent/config fields deliberately

Use the [v2 agent documentation](https://opencode.ai/v2/docs/agents/) and the candidate runtime's matching schema as authority. The conversions below preserve this template's intent; they are not a mechanical search-and-replace recipe.

| v1 field or behavior | v2 staging conversion |
| --- | --- |
| Root `agent` map | Rename to `agents`. |
| Agent `disable: true` | Rename to `disabled: true`. Keep built-ins `build`, `plan`, `general`, and `explore` disabled; v2 has no builtin `scout`, so do not create a `scout` builtin setting. |
| Permission mapping | Replace with an ordered `permissions` list of `{ "action": ..., "resource": ..., "effect": ... }`. Rules are evaluated in order and the **last matching rule wins**. For this template's unrestricted policy, use a catchall allow at both root and each agent; remove or supersede inherited narrower asks/denials in the resolved config. |
| Permission action `bash` | Rename action to `shell`. |
| Permission action `task` | Rename action to `subagent`. |
| Agent role defaults | Add explicit `mode: primary` to Design and `mode: subagent` to every leaf; v2 defaults to primary, so omission could accidentally grant primary status. |
| Semantic color names such as `primary`, `success`, `info`, `error`, `warning` | Replace with six-digit hex color values appropriate to the role. |
| `temperature`, `top_p`, `tools`, `maxSteps` | Remove these unsupported/removed settings from the staged v2 agent configuration. Do not move temperature to request-agent overlays as if that would make it active: request overlays are currently preserved but not sent. |
| Markdown agent body | Body remains the system prompt. Convert any JSON `prompt` field to the v2 `system` field. |
| `subagent_depth` | Do not add or assume a replacement setting; it is absent from this v1 template and no v2 depth behavior is assumed here. |

This template intentionally has no permission-based role allowlists or runtime restrictions. In v2 staging, set this catchall at the root and repeat it for every template agent. The last-match rule means inherited or otherwise later matching asks/denials must be removed or superseded in the resolved config, with the resolved outcome inspected before reliance. Do not add deny/allowlist examples for tools, skills, files, or delegation. Role boundaries remain prompt instructions only.

For example, after confirming that the selected v2 schema uses `*` for every action and resource, both root and each template agent use this staged permission list:

```json
[
  { "action": "*", "resource": "*", "effect": "allow" }
]
```

Confirm wildcard and resource semantics against the chosen v2 schema before using the staged example. Inspect the resolved root-plus-agent permissions to ensure there are no later matching ask/deny rules. If external policy still blocks an action, report it; do not claim the template bypasses controls outside OpenCode.

Disable v2 built-in agents explicitly using `agents.<name>.disabled` for `build`, `plan`, `general`, and `explore`. Do not rely on old config layout or v1 fallback behavior.

## 3. Verify identity and model selection

The selected model for a session persists independently of agent selection. For a fresh staged primary session, explicitly choose and verify `github-copilot/gpt-6.1-sol` for Design. Confirm the actual selected model for child sessions as well; do not assume changing agents changes model selection or that a missing pin falls back correctly. The normal pin remains `github-copilot/gpt-6-luna`; account discovery on 2026-10-19 showed no 6.1 Luna. Catalog discovery alone does not prove a child can use its assigned model; the approved staging smoke below must verify actual child identity. See [model policy](model-policy.md).

## 4. Plan authentication migration without exposing secrets

In v1, auth is stored at `~/.local/share/opencode/auth.json`. In v2, saved API/OAuth accounts are stored server-side in SQLite. Supported legacy credentials are imported during database migration, but later account updates are **not written back** to `auth.json`.

- Back up relevant user data securely outside Git before launching v2; never print tokens, share raw credential files, or assume/inspect an undocumented `auth.db` path or schema.
- Validate migration using a disposable profile/user or a user-managed environment with throwaway data and explicit approval. Do not prescribe fake OAuth injection or test against production credentials.
- For GitHub Copilot, use the documented `/connect` device OAuth flow, then `/models` to refresh the active account's model list. Confirm account availability and the two exact model pins without exposing credentials.
- Do not attempt a credentials migration or auth test in this template task. The account and database migration remain unverified until a human-approved staging run.

See the v2 [provider guide](https://opencode.ai/v2/docs/providers/) and [provider CLI guide](https://opencode.ai/v2/docs/cli/providers/) for current behavior.

## 5. Staged acceptance gates and rollback

Before calling a v2 migration accepted, require all of the following on the chosen runtime and a disposable/user-managed staging profile:

1. Validate staged configuration against that runtime's matching schema and configuration documentation.
2. Confirm only Design is primary, all role modes are explicit, exact model selections persist for a fresh primary and child session, and built-ins remain disabled.
3. Inspect resolved ordered permissions at root and per agent and confirm the unrestricted catchall allow is effective without later matching ask/deny rules. Role behavior is evaluated from prompts and task outcomes, not permission-denial probes; scout/reviewer intent, worker scope, and tester-only execution remain instructions, not denied capabilities.
4. Use a human-approved, disposable/user-managed staging profile to run a minimal tester-executed live smoke of a fresh Design session and one delegated child on the assigned pins. Record exact selected model identity for both and verify each completes its bounded task according to prompt role intent. Do not use production credentials or expose secrets.
5. Verify v2 Copilot connection and model-list refresh through the documented `/connect` and `/models` flows without exposing secrets. In the approved disposable profile, validate supported auth import and a subsequent account update. Record completion and cleanup/rollback evidence, including removal or reset of disposable profile data by its owner.
6. Exercise representative non-inference config/schema inspection and collect exact runtime/schema version evidence. These checks alone do not establish v2 readiness: the approved live child-model, permission, and auth-usability smoke gates are required for acceptance. Do not infer readiness from successful file conversion alone.

If a gate fails, stop using the candidate profile and runtime, preserve diagnostic evidence without secrets, and restore the previous runtime/configuration from the secured backup. Do not delete or rewrite v1 auth data as an improvised rollback. Keep the active v1 template unchanged until a separately reviewed migration is accepted. No v2 acceptance gate has been run by this documentation change. Any live smoke requires explicit human approval, is executed by the assigned tester in staging, and must record exact model identity and cleanup evidence.

## References

- [OpenCode v2 documentation](https://opencode.ai/v2/docs/)
- [Agents](https://opencode.ai/v2/docs/agents/)
- [Providers](https://opencode.ai/v2/docs/providers/)
- [Provider CLI](https://opencode.ai/v2/docs/cli/providers/)
- [Latest stable release](https://github.com/anomalyco/opencode/releases/latest)
