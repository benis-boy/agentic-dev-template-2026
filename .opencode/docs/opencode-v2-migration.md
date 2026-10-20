# OpenCode V2 Native Configuration and Migration

**Status: the reusable source template has been converted to native OpenCode V2 configuration and agent-definition shapes. Runtime acceptance remains unverified.** This change does not upgrade or install OpenCode, packages, or credentials and does not test a live model call. Do not use a V1 runtime with this V2-only active configuration: on a V1 destination, keep the active config/agents unchanged until a separately approved upgrade to a compatible V2 release. For first install and reconciliation, follow [`install.md`](../../install.md) and [`update.md`](../../update.md); this guide describes behavior and verification, not permission to change runtime/auth state.

The V2 migration is optional in OpenCode generally. This template adopts the native format for clarity and consistency. Start from the full [V2 migration guide](https://opencode.ai/v2/docs/migrate-v1) and exact runtime docs; V1 supported functionality is intended to remain compatible, but a template configured with V2-only native fields must not be pointed back at V1. V1 and V2 use the same configuration locations, so retain a safe copy before converting a destination.

## Native configuration and permission behavior

The source `.opencode/opencode.json` now uses the following native V2 shape:

| Former V1 field/behavior | Native V2 form in this template |
| --- | --- |
| `permission: "allow"` | `permissions: [{ "action": "*", "resource": "*", "effect": "allow" }]` |
| `agent` map | `agents` map |
| `agents.<id>.disable: true` | `agents.<id>.disabled: true` |
| Design default | `default_agent: "design"` (unchanged) |
| Schema URL | `$schema: "https://opencode.ai/config.json"` (unchanged) |
| Source-only maintainer instruction | Retained in this source checkout; omit that entry and rule when installing in a destination |

The built-in `build`, `plan`, `general`, and `explore` agents stay disabled. V2 has no built-in `scout`; Scout remains a template-defined agent role, not a builtin config entry. The repository's active `agents` definitions use native V2 frontmatter and role modes. The JSON schema URL is retained for editor validation; it is not used here as authority for V2 shape because it accepts deprecated V1 fields too.

The wildcard permission rule is intentionally broad: it allows every action on every resource, including paths outside the project. Do not add an `external_directory` ask rule to this template. Template role distinctions (including read-only Scout/Reviewer intent, bounded Worker scope, and tester-only execution) remain prompt instructions, not technical restrictions or security boundaries. OpenCode's ordered rules and higher-level policies still apply. During a destination merge, inspect its effective policies and preserve unrelated meaningful asks/denials; obtain explicit approval for a material conflict rather than deleting or superseding restrictions indiscriminately. This source config is not a security-policy template for untrusted agents or inputs.

## Agent definition mappings

Native V2 agent fields used by the template follow the official [agents guide](https://opencode.ai/v2/docs/agents):

| V1 field/behavior | V2 treatment |
| --- | --- |
| `permission` mapping | Ordered `permissions` rules; the template catchall is `{ "action": "*", "resource": "*", "effect": "allow" }` |
| `disable` | `disabled` |
| Role kind | Explicit `mode: primary` for Design and `mode: subagent` for leaf roles |
| Semantic UI color names | Six-digit hex colors |
| `temperature` | Removed from agent definitions. It is not restored via `request.body`: V2 currently preserves request overlays but does not send them with model requests, so that would not preserve active behavior. No active temperature setting is claimed. |
| Markdown agent body | Remains the system prompt; no JSON `prompt` field is used |
| Model pin | Exact provider/model pins remain as assigned; availability and live selection are not verified by this conversion |

Do not add technical role allowlists, shell restrictions, or `external_directory` prompts as a migration “hardening” step. The agent prompts express their assigned ownership and task boundaries. A destination may have its own policy; preserve it unless a separately reviewed, approved merge changes it.

## Onboarding and compatibility boundaries

- **V2 destination:** inspect the exact OpenCode release's config and agent docs, preserve its unrelated settings, review the permission effects, and merge only with approval. Restart OpenCode after compatible config/agent/skill/command changes and resume in a fresh session.
- **V1 destination:** stop the active config/agent merge. Do not paste native V2 fields into V1 or silently upgrade/downgrade the runtime. Continue only after a separately approved runtime upgrade and exact-release review.
- **Runtime absent:** record runtime/environment readiness as pending. Do not install a host V1 runtime as a prerequisite for V2 container work. A separately approved human/operator may follow the devcontainer instructions as plain text; this does not itself install or authenticate OpenCode.
- **First install vs reconciliation:** first install may initialize destination goals only after compatible runtime and command/Design registration are confirmed and after required approvals. Reconciliation preserves existing goals and evidence; do not rerun `/init-goals` by default.
- **Distribution exclusions:** omit source-only `.opencode/rules/template-maintainers.md`, its `instructions` entry in source `.opencode/opencode.json`, and `.opencode/docs/template-onboarding.md`; preserve unrelated destination rules/instructions. Apply dynamic inventory to all other distributable assets.
- **No unsolicited side effects:** this migration does not upgrade the Node/OpenCode versions, touch package manifests/locks, install plugins, change container/runtime configuration, authenticate, copy sessions, invoke `/devcontainer`, or stage/commit/push files. Existing approval gates for runtime, auth, container generation, and destructive changes remain separate.

The V2 migration guide states that existing command and skill definitions remain supported; this template's command and skill files do not need format changes. There is no active plugin or server API consumer in this template. `.opencode/package.json` names `@opencode-ai/plugin`, but it has no evidenced consumer; leave the ignored manifest/lock and dependencies unchanged. Plugin and server API migration are outside this config conversion.

## Verification and known gaps

The conversion records intended file shapes, not runtime acceptance. As part of this change, no V2 runtime config inspection, model selection, inference, child-agent execution, permission resolution, login, auth import, or credential validation was performed. Acceptance remains **UNVERIFIED** for native config loading, the live Design/child model pins, actual agent behavior, and current authentication. Do not claim model calls or runtime compatibility were tested.

For a separately approved V2 acceptance exercise, use the exact selected release's CLI help and config/agent/permission docs to inspect the resolved config, confirm Design is the default primary and each role's mode/model, verify the four built-ins are disabled, and inspect effective permissions without probing role enforcement as a technical denial. Any live model/auth exercise requires separate human approval and a tester-owned, appropriately isolated profile; record exact model identity and cleanup evidence without exposing secrets. A static file review does not substitute for those checks.

### Historical devcontainer authentication evidence (separate scope)

The root devcontainer's exact-release notes retain historical evidence for the `@opencode/cli` v2.0.32 selection and its supported host OpenCode V1 GitHub Copilot credential import path. That previously implemented container path stages one existing host auth file only under its explicit approval gates and imports into its isolated persistent data volume; it does not establish general V2 auth readiness, token validity, model availability, or successful inference for this native-template migration. This document change did not run or alter that flow. Keep its separate runtime/auth gates and verification limitations intact.

## References

- [V2 migration guide](https://opencode.ai/v2/docs/migrate-v1)
- [V2 configuration](https://opencode.ai/v2/docs/config)
- [V2 agents](https://opencode.ai/v2/docs/agents)
- [V2 permissions](https://opencode.ai/v2/docs/permissions)
- [V2 providers](https://opencode.ai/v2/docs/providers)
- [V2 provider CLI](https://opencode.ai/v2/docs/cli/providers)
