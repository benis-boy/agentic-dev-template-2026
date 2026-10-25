---
description: Initialize a deeply researched advisory council or reconcile an existing council's coverage
agent: design
subagent: false
---

Initialize or refresh a reusable advisory council for this subject or ambition:

$ARGUMENTS

## Read first and establish scope

Read `.opencode/docs/council-of-experts.md` **fully before proceeding**. If it is missing or cannot be read completely, stop and report the missing prerequisite; do not reconstruct it from this command. Its detailed contracts complement the operational requirements below. Report material conflicts rather than inventing precedence.

This invocation commissions setup within its stated scope, not implementation of the subject itself. Stay in the existing Design root session: the manager cannot bootstrap itself. Read applicable project instructions and relevant canonical project context explicitly; neither links nor stored `@path` text loads file contents. Treat template placeholders as placeholders, not project facts. If the subject is empty and indispensable intent cannot be established from the invocation context, ask one focused subject/ambition question before research or writes; do not invent a trial topic.

Establish **new initialization versus existing-council reconciliation/refresh** from invocation intent and actual definitions/notes, including partial outputs; do not invent mode flags. For an existing council, preserve its mandate, members, exact IDs, notes, supported findings, and local adaptations. Compare actual project evolution and current reusable contracts with those assets; map relevant disciplines, consequential questions, and risks to existing expertise, identifying inadequate or missing coverage rather than replacing the roster by default. Resolve consequential mandate conflicts or proposed mandate changes with the user; ordinary in-scope role design and repair need no per-expert approval.

Infer the advisory scope, likely consequential questions, constraints, and useful expertise from the subject and available facts. Do not infer an expanded Design decision remit. The exact remit for consequential direction/product-policy decisions and possible council read-only goals access remain undecided; neither is a bootstrap dependency. Council agents never write, update, or maintain the goals skill or goal/proof records and do not read them by default. Leave source-template goal/proof/index seeds pristine; ordinary destination Design record duties remain outside council ownership.

Minimize interruptions. Ask only when genuinely missing intent, consequential scope, resources/authority, or preferences prevent responsible progress. Prepare concise recommended A/B alternatives with concrete trade-offs where meaningful; allow redirection rather than inventing a binary. Independently handle ordinary source selection, roster design, technical planning, and in-scope recovery. Do not require per-source, per-role, per-asset, technical-plan, or activation approvals. The user's actual invocation scope controls authority; existing environment approvals and tool permissions remain binding, and no real paid commitment beyond that scope is authorized.

## Research to fit initialization or refresh

The broad-to-deep initialization requirements below apply to **new councils**. For **existing-council refresh**, reuse supported research and target new, missing, changed, stale, or conflicting evidence and coverage gaps; do not rerun broad initial research by default. Set finite refresh coverage/stopping criteria around those gaps, retain applicable curation practices below, and disclose remaining uncertainties.

Make substantial, potentially massive **online-first subject research the dominant initialization effort**, before finalizing the roster. A repository inspection, a couple of queries, or unsupported model recollection is not sufficient. Use many searches and source reads across broad-to-deep passes as warranted. Local project records and implementation constrain applicability; they neither replace nor bound the online investigation.

Set a substantial but finite initialization research scope with coverage and stopping criteria suited to the ambition. Delegate bounded read-only discovery through available specialists where useful, supplying the actual outcome, context, boundaries, and expected evidence. Front-load as close to all predictable, decision-relevant research as practical: likely consequential options and trade-offs, domain practices and failure modes, security and operational risks, dependencies, integration, compatibility, and other subject-relevant disciplines. Adapt these categories to the subject rather than filling irrelevant sections. Prefer authoritative current official sources, primary research, and other high-quality evidence; investigate conflicts and check applicability instead of counting citations.

Work from an evidence/coverage map toward deeper investigation of material uncertainties and cross-domain dependencies. Finalize roles only after predictable decision-relevant findings are adequately covered and further passes yield diminishing consequential findings, or report why capacity/sources prevent that coverage. Disclose every known critical gap; do not label blocked research complete or promise universal knowledge. Do not invent a universal numeric budget or ask the user to set call limits. Initialization has its own substantial finite scope, separate from later task/initiative consultation allowances.

Curate reusable shared foundations and specialist findings with material source links and enough context to support later use. Preserve disagreements, applicability limits, uncertainties, and missing expertise; distinguish observations from inference and recommendation. Derive a broad but bounded roster from substantive needs, not fictitious salaries, prestige, personas, or a target headcount. Meaningful differences may justify overlap; every imaginable specialty is not completeness. Keep the full research corpus out of each prompt. Later tasks should reuse curated findings and research uncovered, changed, stale, or conflicting points selectively—not repeat broad initialization research by default.

## Ground at least one member in the existing codebase

For either mode over an existing codebase, ensure at least one substantive expertise-defined member has evidence-based general source-code understanding. An existing suitable architect/generalist may qualify; neither a title nor a documentation summary establishes coverage, and no new name is mandatory. Commission bounded read-only code discovery covering entrypoints, main modules/runtime boundaries, key flows/data, integrations/dependencies, canonical code/config paths, architecture constraints, and inspection gaps. Reuse supported orientation and inspect relevant changes/gaps on refresh; do not require every expert to inspect all code or repeat full discovery each task.

Supply inspected paths and concrete code-grounded findings to role selection/definition: designate the source-aware member's substantive remit and require explicit loading of relevant current notes and canonical code/config context for each task. Through the note owner below, retain concise source navigation, architectural orientation, and inspection limitations in current shared/member notes, not source dumps or claims of automatic memory. For empty/no-source projects, report this requirement pending until implementation exists; invent neither code nor an expert's knowledge. No goal/proof read is a prerequisite.

## Commission artifacts and reconcile ownership

Inspect existing council assets, affected operational instructions, and any partial writes before changing them. On retries reconcile the intended scope with current contents, preserving unrelated content and supported findings. Do not blindly overwrite existing councils, destructively roll back partial work, or silently repurpose a conflicting mandate; report consequential conflicts.

Design directly commissions `agent-maintainer` for new or reconciled definitions **and affected operational instruction reconciliation together**, including applicable role maps and `AGENTS.md` guidance. Supply the researched mandate, evidence summaries, explicit ownership boundaries, exact output paths/IDs, and the task's scope; do not seek per-asset approval. The council output contracts are:

| Path | Required purpose |
| --- | --- |
| `.opencode/agents/council/Manager.md` | Exact ID `council/Manager`, native V2 `mode: primary`; a separate advisory root, not a delivery coordinator. |
| `.opencode/agents/council/<expert>.md` | Matching exact ID `council/<expert>`, native V2 `mode: subagent`; substantive expertise-defined advisory leaf members. |
| `.opencode/docs/council/shared.md` | Current curated shared foundations and applicable project context. |
| `.opencode/docs/council/<expert>.md` | One current sourced specialist note per member, including relevant context, dependencies, disagreements, and gaps. |

Have the maintainer consult the current official [V2 Agents documentation](https://opencode.ai/v2/docs/agents) for changed definition fields. Put selection-critical expertise in discoverable descriptions and essential role behavior inline. A folder supplies neither memory nor isolation; primary/subagent modes and Markdown paths do not establish transport, recognition, or policy enforcement. Do not add speculative permission or model controls.

Assign an active, in-scope `council/Manager` as note publisher only within explicitly assigned documentation-only scope; experts research and propose sourced amendments. **Only during initial bootstrap**, if the manager cannot yet publish initial notes as a supported separate root, Design assigns a bounded general-documentation owner to publish the researched notes and reports manager publishing as unconfirmed. For an existing council without an active/in-scope manager, report the exact outstanding note refresh; do not appoint a standing Design alternate publisher or automatically wake a root. Never invoke a child manager as a workaround. Notes are derived context: canonical project records and relevant implementation/configuration remain authoritative. Distinguish proposed, accepted, planned, implemented, and verified state. Publish amendments serially from the current note, preserving supported findings and resolving contradictions against canonical evidence; this practice is not a lock guarantee.

Fresh task sessions must explicitly read the relevant current notes, shared foundations, and canonical context; links are not loading and no remembered or pending facts carry over. Verify material unknowns or conflicts through targeted inspection/research, not automatic whole-project rediscovery. Do not create council versions, revision/source-base markers, freshness ledgers, change cursors, queues, automatic wakeups, or a memory service. Note maintenance cannot rewrite instructions or canonical decisions. Definition/mandate changes return to maintainer ownership; unattended maintenance needs are reported, not queued or promised.

If supported runtime/configuration integration is warranted within this invocation's scope, Design commissions the appropriate implementation owner for that bounded work; the maintainer does not own executable infrastructure or JSON integration. Preserve unrelated configuration and existing ownership boundaries. Do not add a separate plan/activation approval ceremony, silently broaden the task, or invent runtime mechanisms.

## Preserve consultation boundaries in the generated instructions

- Design and `council/Manager` are distinct roots. Design remains never-subagent; neither root launches the other as a child. Members advise only the manager and never delegate, dispatch, implement, edit instructions, or run tests. The manager synthesizes advice and publishes only assigned derived notes; it does not implement, execute tests, edit definitions, or own canonical project records.
- Select only members needed for complete relevant coverage of each question. Explain material gaps and non-obvious omissions, not every inactive member. Collect one independent assessment from each selected member, allowing targeted research within that assignment. Permit **at most one focused follow-up round**, only for actual conflicting conclusions/assumptions critical to the decision, correctness, or a serious risk, and only with the relevant members. Uncertainty alone, minor differences, or a desire for consensus does not justify re-questioning. Preserve unresolved dissent in a qualified answer or blocker.
- Design sets sensible finite consultation/follow-up/retry/attempt/time limits and a stop condition within the user-initiated task/initiative. Requests must carry their actual question, owner, scope, relevant context, task/initiative/request correlation, and shared remaining allowance. Repeated requests, follow-ups, technical retries, new IDs, and session/context resets for the same task/initiative consume the same allowance; none replenishes it. A continuation missing established scope or remaining allowance blocks, rather than assuming a fresh budget. Stop on exhaustion; do not turn ordinary limits or recovery into a user questionnaire.
- Direct informational requests and correlated answers between roots are the target, without a user courier or extra consultation approval. A response closes only its requesting Design task's matching request, cannot initiate another consultation or implementation task, and cannot authorize action after cancellation. Council-originated implementation proposals require a user-authorized/carried bounded brief to Design; informational replies are not such dispatch. Advice never expands scope or replaces independent review and tester-owned verification.
- Partial failure calls for a useful bounded technical retry, qualified synthesis with missing coverage disclosed, or a blocker within the same allowance—not routine second opinions or an ordinary recovery questionnaire. Stop when answered, canceled, blocked, exhausted, or no useful new information is likely.

## Establish feasibility, review, and report without overclaiming

Use current official documentation and actual available runtime capabilities to determine supported recognition, separate-root session selection/start, explicit context loading, and direct request/reply behavior. Do not invent commands, APIs, registrations, recursion counters, locking, permission inheritance, or transport. Selecting an agent is not proof of starting a separate root; prose is not technical enforcement.

Direct consultation requires evidence of correct task/request routing, sufficient context, cancellation handling, reply-versus-dispatch boundaries, and the shared finite allowance across retries, new IDs, and session/context resets. If any required mechanism cannot be demonstrated, block that direct-consultation capability and name the missing evidence. This does not block otherwise in-scope research or authored artifacts. Do not substitute a child manager or claim a manual courier fulfills direct consultation. State any confirmed reload/new-session requirement; if an edited nested `AGENTS.md` below the session workspace was already loaded and its updated guidance must apply immediately, report the need for a new session. Ambient global/upward-discovered `AGENTS.md` edits update before the next model request and do not require that restart.

Obtain appropriate independent read-only review of the generated contracts and notes. Delegate relevant runtime/static/integration checks to the appropriate tester; Design and instruction authors do not execute tests. Scope checks to the actual later outputs and environment, following the destination project's verification policy. Static Markdown review cannot prove runtime recognition, root transport, note loading/publication, loop enforcement, or improved research efficiency/quality. Report unexecuted or blocked checks and their limitations without treating them as passed.

Finish with a concise report separating:

1. Initialization versus refresh, authored/reconciled paths and their ownership; preserved adaptations and staged, partial, conflicting, or incomplete work, including outstanding note publication.
2. Research scope and reused/new evidence, citations, material gaps, uncertainties, and roster sufficiency against relevant disciplines/questions/risks; any inadequate or missing roles. Name the designated source-aware expert, inspected code evidence and inspection gaps, or the pending no-source requirement, separately from runtime availability.
3. Runtime recognition of definitions.
4. Separate-root session availability/selection, distinct from recognition.
5. Direct request/reply routing and cancellation evidence or blockers.
6. Context/allowance continuity and enforcement evidence or blockers, and note-loading/publication status.
7. Independent review/check evidence, remaining limitations, and any justified next action within scope.

Do not call the council ready merely because files exist or assert performance benefits without evaluation. End idle: no whole-roster convening, automatic Design launch, subject implementation, or pending wakeup. Later task-scoped consultation remains selective and advisory.
