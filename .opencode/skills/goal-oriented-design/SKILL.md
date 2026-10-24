---
name: goal-oriented-design
description: Use broadly for design work involving product goals, product-code, behavior, verification, or goal documentation; provides the goal workflow and proof inventory for the primary Design agent.
---

# Goal-Oriented Design

Before mapping work, read the [reference index](references/index.md) and the
relevant goal tree. Before choosing verification, read the relevant proof
inventory. Read the relevant ancestors and affected branches, not the whole tree.

Goals describe product outcomes across implementation boundaries; they are not a decomposition of services, packages, APIs, tables, or tasks.

Use [references/goal-tree.md](references/goal-tree.md) as the current target-state hierarchy. Follow its links only when the touched branch needs deeper context.

## Record Boundaries

- The goal tree owns approved enduring outcomes, conservative summary statuses, authoritative specification links, and optional decision-relevant current limitations. Keep detailed discovery rationale in the proposal, not the written hierarchy.
- The proof inventory owns reusable coverage and qualification contracts: asserted outcomes, stable test selectors and commands, required boundaries and environment assumptions, prerequisite/cleanup ownership, and coverage gaps. Keep stable test IDs here, not in goal statements. Prefer canonical runner, environment, and setup references over copied instructions in every row.
- Existing task, CI, or report systems hold execution-specific results, revisions, environments, and artifacts. Do not create a run-log system or append run histories to goals or inventories. Relevant authoritative decisions/incidents and reusable manual procedures may still be linked; a dated manual check does not qualify as required automated E2E proof.

Prefer stable document sections or symbols over working-tree line numbers in persistent records; transient discovery and review packets may use line references. Keep small projects in one concise tree and inventory. Split cohesive outcome branches through the index only when needed for scoped reading, not by default.

## Initial Setup And Rebaselining

When this skill is first installed in a project, or when its goal tree is known to be stale, delegate repository and documentation discovery to a read-only scout. Require it to return:

- the overarching goal stated by product direction;
- a high-level outcome tree inferred separately from documentation and implemented source behavior;
- evidence links and implementation status for each proposed goal;
- candidate leaf-to-E2E mappings and proof gaps;
- contradictions and aspirational examples that should not be treated as current capabilities.

Present the extracted goals to the user for correction and explicit approval of the current proposal before writing inferred target-state additions. Corrections alone are not write approval. Read and follow the [initialization command](../../commands/init-goals.md) for its two-phase approval workflow when initializing or rebaselining. Do not organize the result by service. Store only the approved concise hierarchy in the goal-tree reference and link deeper descendants to product documentation.

## Required Design Workflow

For every prompt where this skill is useful:

1. Reject designs that advance a child outcome while undermining a parent outcome; goals describe target state rather than prescribing architecture.
2. Whenever Design communicates goals to any subagent, write every relevant goal and necessary parent outcome in plain text in that assignment. IDs may accompany the text for traceability, but never substitute for it; links and references must never be required for the subagent to understand the outcome.
3. If implementation establishes, removes, or materially changes a target, update `references/goal-tree.md` and [references/e2e-proof.md](references/e2e-proof.md) in the same change. Update the inventory for relevant selector, coverage, or boundary changes even when outcomes are unchanged; do not rewrite accurate records merely for a refactor. Update linked product documentation when the user requests it or when the implemented behavior makes that documentation inaccurate.
4. Treat existing outcomes indirectly affected through changed contracts, authorization, shared dependencies, persisted data, or workflow transitions as touched too. Read their proof mappings and select targeted checks for the changed and regression-sensitive outcomes; report uncovered risks. This does not require whole-tree reading or full-suite execution for every change. Design delegates execution to the appropriate tester.
5. In the final result, name touched goal IDs and summarize verification evidence or proof gaps.

When the prompt does not map cleanly to the tree, do not force it under a nearby goal. Determine whether it is an implementation detail that supports an existing goal or evidence of a genuinely missing target-state branch. Add a goal only when it expresses an enduring user or product outcome across implementation boundaries.

## Goal Quality Rules

- A high-level goal states a durable product outcome and remains meaningful if services, storage, or APIs are reorganized.
- A child narrows its parent's outcome. It does not merely list the mechanism used to fulfill it.
- Keep this skill compact. Put deeper child goals in linked product documentation rather than copying their detail here.
- Use exactly these statuses: `target` means intended but not implemented; `partial` means only part of the outcome is implemented; `untested` means implemented but required qualifying coverage or applicable successful execution evidence is missing; `done` means implemented with all required qualifying coverage and applicable successful execution evidence, after any explicit goal-scoped [user exemption](#user-waivers). Test presence alone or E2E success without the other required independent proof is insufficient. Assess mixed branches conservatively: a parent remains partial when any essential child outcome is incomplete or lacks remaining required proof.
- Treat examples and ideas as candidate outcomes, not automatically current goals. Adopt them only when repository evidence or explicit product direction supports them.

## Leaf-Goal Proof Contract

By default, every leaf goal requires multiple independent automated tests, including at least one e2e
test in a production environment. Tests create and clean up their own
prerequisites using the fastest suitable method. A qualifying inventory entry:

- records the project's descriptive test kind (such as unit, integration, contract, or e2e) separately from whether it qualifies for the required E2E proof;
- records cleanup ownership and stable commands where useful;
- proves a product outcome, not merely that an endpoint returned or a component rendered.

For this contract, a **production environment** exercises production implementations and the real required service boundaries. It may be local, CI, staging, or deployed production; it does not mean customer production. An e2e test may not replace a required production dependency with a fake or mock.

Independent tests provide meaningfully distinct failure coverage, not renamed duplicates. A suite may map to multiple leaves only where it actually asserts each outcome. Distinguish discovered tests, qualification by inspection, and applicable successful execution evidence from established results. Reassess applicability after relevant implementation, test, dependency, or environment changes; do not impose arbitrary expiry dates or downgrade automatically on every commit. Known outcome defects or remaining required relevant failures cannot justify `done`. Reflect substantive status changes without persisting run-by-run facts.

Other tests may use fakes and mocks where appropriate; there is no blanket mock ban. Under the default contract, unit tests alone cannot advance a leaf beyond `untested`. Split long processes into short independently verifiable transitions; A=>C may be established by A=>B and B=>C when B's identity and contract are asserted. When relying on that decomposition, inventory the transition suites and intermediate identity and contract. UI-only outcomes are proof of product goals, not product goals themselves. Migrations are implementation mechanisms, never product goals.

Libraries have independent lifecycles: each library has its own root goal, leaf hierarchy, test environments, and proof inventory. Map library outcomes to product goals only where appropriate; do not nest technical library details in the product tree.

## User Waivers

Only an explicit user instruction may waive automated test creation and/or execution, within its stated scope; default to task-specific scope. Never infer a waiver from perceived triviality, deadlines, or a missing environment. “Do not run tests” waives execution only, not authoring or standing goal proof requirements. “No tests needed for this typo fix” requires no new test suite for that task, not a permanent goal exemption.

A task waiver stays in the task/final report: it neither establishes goal `done` nor erases existing unrelated evidence gaps. Only an expressly goal-scoped exemption changes the standing leaf proof contract. Record its scope, the specific requirements exempted, and the user's rationale if supplied concisely in the proof inventory—not as a new outcome, status, or dated run history. Assess `done` against implementation and all remaining applicable requirements; do not demand nonexistent results for expressly exempt requirements. No waiver excuses known incomplete or defective outcomes or remaining required relevant failures.

Waived proof is not passed proof. Report what was not checked and residual uncertainty without inventing automated success. Preserve default requirements outside the exemption, approval gates for persistent writes, and tester ownership for checks that do run.

## Required Design checklist

- Read the relevant tree before mapping and the relevant proof inventory before verification selection.
- State every relevant outcome, including parent outcomes, in plain text in every subagent assignment.
- Keep goals durable and concise; keep stable test IDs in proof inventories only.
- For a specific Playwright delegation, prefer a stable exact test ID or title and provide the exact command; use a path only to disambiguate.
- Reconcile mixed statuses conservatively and report proof gaps honestly.
