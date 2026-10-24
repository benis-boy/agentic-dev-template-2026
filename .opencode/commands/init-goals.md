---
description: Infer and seed project goal documentation with human approval
agent: design
---

Initialize or rebaseline the project's goal documentation. This command has two
approval-gated phases. Complete Phase 1, present its result, and stop. If the
human requests corrections, present the revised proposal and stop again. Perform
Phase 2 only after the human explicitly approves the current proposal for write.
For template onboarding, first read `docs/template-setup.md` when present. Keep
the recorded original product-goal input distinct from inferred/approved goals.
Never populate the intentionally uninitialized goal-tree, proof-inventory, or
index seeds from this template's own onboarding outcomes. On template update,
preserve existing goal documentation; do not reinitialize by default.

## Phase 1 — Discover and propose

1. Load `goal-oriented-design`. Read its reference index and the existing goal
   tree and proof inventory, including separate library references relevant to
   the initialization scope. For bounded rebaselining, read the affected branches
   and ancestors rather than unrelated trees. Treat an uninitialized seed as
   empty rather than as product direction.
2. Map the repository before proposing goals. Delegate bounded read-only scouts
   where context isolation or parallel inspection is useful. Keep these evidence
   streams distinct:
   - authoritative product direction and capability boundaries in project
     guidance and product documentation;
   - implemented user-visible behavior and durable data or workflow contracts;
   - tests, runners, and environments that may prove leaf outcomes, separately
     from established execution results and their applicability.
3. Ask discovery scouts to report concrete file or symbol evidence, observed
   behavior, implementation gaps, contradictions, and ideas that are merely
   aspirational. For test discovery, require exact stable test IDs or titles,
   exact runnable commands when established, project test kind, E2E qualification,
   environment, real versus replaced dependencies, prerequisite creation,
   cleanup ownership, and the
   product outcome asserted. Inspect established execution results when available
   and assess their applicability; never infer success from test presence. Do not
   execute tests anywhere in this initialization command.
4. Synthesize a concise candidate hierarchy organized by durable user or product
   outcomes—not services, packages, APIs, tables, migrations, UI screens, or
   implementation tasks. A child must narrow its parent. Keep independent
   libraries under separate roots with separate proof inventories; link a
   library outcome to a product goal only when evidence supports that relation.
5. Assign only `target`, `partial`, `untested`, or `done`, using the definitions
   in the skill. Derive status from evidence, assess mixed parents
   conservatively. A leaf is `done` only when implemented with qualifying coverage
   and applicable successful execution evidence for all remaining requirements.
   The default is multiple independent automated tests, including at least one
   qualifying real-boundary E2E test. Apply the loaded skill's User Waivers rules:
   do not require results for expressly exempt requirements or treat task-only
   waivers as goal exemptions. Otherwise an implemented leaf remains `untested`;
   known outcome defects or remaining required relevant failures cannot justify
   `done`.

Present a review packet containing:

- the candidate overarching outcome and numbered outcome tree;
- for each goal, its proposed status, concise rationale, and authoritative
  evidence links;
- contradictions, assumptions requiring confirmation, omitted aspirational
  ideas, and uncertain capability boundaries;
- candidate leaf-to-proof mappings with qualification, cleanup, and applicable
  execution-evidence gaps, distinguishing explicit goal-scoped exemptions from
  missing proof;
- the exact files that Phase 2 would change.

Ask the human to approve the proposal for write or provide corrections. A
correction is feedback, not write approval: incorporate it into a revised review
packet and ask again. Do not modify the goal tree, proof inventory, reference
index, or product-direction documentation in Phase 1. Never fabricate goals,
statuses, test qualification, commands, dependencies, environments, or cleanup
behavior.

## Phase 2 — Seed approved documentation

After explicit human approval of the current review packet, recheck the files
named in that packet. If relevant evidence or destination content changed,
report the difference and return to Phase 1 rather than overwriting it. Otherwise
update only the approved scope:

- `.opencode/skills/goal-oriented-design/references/goal-tree.md` with the
  concise approved hierarchy, statuses, and links to deeper authoritative
  specifications, with only decision-relevant current limitations—not detailed
  discovery narratives or dated run observations. Prefer stable specification
  sections or symbols over working-tree line anchors;
- `.opencode/skills/goal-oriented-design/references/e2e-proof.md` with inspected
  reusable coverage/qualification contracts and explicit gaps, using stable IDs
  and exact commands only when observed; link canonical runner, environment,
  and setup instructions rather than duplicating them. Include concise explicit
  goal-scoped proof exemptions within the approved write scope, not task-only
  waivers or fabricated passed results;
- `.opencode/skills/goal-oriented-design/references/index.md` with product and
  independent-library references;
- approved independent-library goal trees and proof inventories in distinct
  reference files, creating and linking them from the index when needed rather
  than merging them into the product files;
- established product-direction documentation such as `AGENTS.md` only when
  the approved outcomes make it inaccurate or incomplete and ownership permits
  the edit.

If writing stops partway through, report the files updated, files still pending,
and any inconsistent goal/proof/index state. Do not roll back unrelated edits or
blindly repeat Phase 2. Before resuming, recheck the current files against the
approved packet; return to Phase 1 if its evidence or approved scope has changed.

Create a proof-inventory mapping for every approved leaf, even when no qualifying
test exists; distinguish coverage gaps from explicit goal-scoped exemptions.
Shared suites may map to several leaves only where they assert each outcome.
Apply the skill's status rules: implemented leaves without all remaining required
qualifying coverage and applicable successful execution evidence remain
`untested`; leaves not fully implemented
retain `target` or `partial` as appropriate. Keep execution-specific results in
existing task, CI, or report systems, not goal/proof run logs. Preserve accurate
existing guidance. Do not turn uncertain evidence into an authoritative target.
Report unresolved contradictions and out-of-scope updates instead of silently
resolving them. Finish by summarizing
written goals, statuses, proof gaps, files changed, and any decisions still
needed; this is a documentation initialization, so do not claim test execution
as verification.
