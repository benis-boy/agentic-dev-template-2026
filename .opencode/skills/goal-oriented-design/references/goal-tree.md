# Product Goal Tree

This seed is intentionally uninitialized. A human must approve inferred goals before they become authoritative. Do not populate it from this template alone.

Goals describe durable user or product outcomes across implementation boundaries, not services, packages, APIs, tables, or tasks. Keep the hierarchy concise and link deeper context to authoritative project documentation.

This tree owns approved outcomes and conservative summary statuses, not test mappings or execution history. Link authoritative specification sections; prefer stable sections or symbols over working-tree line numbers. Record only decision-relevant current limitations, not dated checks or discovery narratives. Keep reusable coverage contracts in [the proof inventory](e2e-proof.md) and execution-specific results in existing task, CI, or report systems.

## Statuses

- `target`: intended but not implemented.
- `partial`: only part of the outcome is implemented.
- `untested`: implemented, but required qualifying coverage or applicable successful execution evidence is missing.
- `done`: implemented with all required qualifying coverage and applicable successful execution evidence. By default this requires multiple independent automated tests, including at least one qualifying real-boundary E2E test; apply only expressly goal-scoped user exemptions, as defined in [User Waivers](../SKILL.md#user-waivers). Test presence alone is insufficient, and waived proof is not passed proof.

Assess mixed branches conservatively: a parent remains `partial` when an essential child is incomplete or lacks remaining required proof.

Reassess proof applicability after relevant implementation, test, dependency, or environment changes, not every commit or an arbitrary time interval. Known outcome defects or remaining required relevant failures cannot justify `done`; summarize substantive status changes without copying run results here.

## Initialization format

After explicit human approval, record an overarching goal and numbered descendants:

```markdown
## G0 — [durable overarching outcome]

**[status] —** [concise outcome statement]

### G1 — [child outcome]

**[status] —** [concise outcome statement]

- **[status] — G1.1 — [leaf outcome]:** [observable outcome]
- Specification: [authoritative section links]
- Current limitation (optional): [concise decision-relevant capability limitation]
```

Maintain separate root trees for independent libraries and link them rather than nesting their technical details here.
