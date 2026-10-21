---
description: Review and improve project Markdown by document purpose, audience, lifecycle, and ownership
agent: design
subagent: false
---

Improve the project's Markdown documentation so it is trustworthy, navigable, and appropriate to its audience. `$ARGUMENTS`, when supplied, gives optional focus areas or priorities; use it to order work, not silently shrink the default full-repository inventory. Do not use shell interpolation for it.

This is a bounded review-and-repair workflow, not a mandate to restructure docs, create a documentation program, or make every file stylistically uniform. Preserve unrelated staged, unstaged, and untracked work. Make small evidence-supported editorial and link fixes; ask the human before semantic changes, material authority changes, or resolving ambiguous conflicts.

## Inventory and map

1. Start at the project root. Read applicable root and nested `AGENTS.md` guidance and your own current prompt. Read linked operational guidance when it applies; links do not load themselves. Never assume a child agent knows a parent or sibling prompt.
2. Inventory first-party Markdown recursively, including hidden directories, root and nested `AGENTS.md`, case-insensitive `.md`, and other Markdown extensions actually used (for example `.markdown`, `.mdx`, `.mdown`, or `.mkd`). Include root and package READMEs, monorepo/package documentation, docs-site content, and MDX. Preserve untracked first-party docs. Do not follow symlinks outside the project.
3. Classify the inventory using the repository's own structure, not a prescribed folder layout. For each family, identify its purpose, audience, package/product area, lifecycle or version applicability, likely owner, canonical source for key facts, and useful adjacent docs. A concise inventory map by family/package is enough; do not create a persistent tracking system or report artifact unless requested.
4. Adapt this taxonomy to what exists: entry-point READMEs and onboarding/contributing; tutorials, how-to/task guides, and exhaustive API/CLI/schema/config reference; architecture, design, security, ADRs, RFCs, specifications, plans, and proposals; operations, runbooks, deployment, recovery, and troubleshooting; changelogs, releases, migrations, deprecations, versioned or archived material; legal/compliance and localized docs; generated reference and docs-site/MDX content. It is a classification aid, not a request to add every document type or create new directories.
5. Exclude dependency/vendor, VCS, build, cache, and generated/artifact areas only when justified by project guidance or evidence, and name those exclusions. Do not blindly ignore generated docs or their links: identify generated outputs and their authoritative source, review references/routing as appropriate, and state what could not be inspected or regenerated. Treat unreadable files and scope exclusions separately from reviewed files.
6. For a large inventory, prioritize shared/canonical documentation and high-dependency navigation first, then work in bounded batches grouped by family/package and adjacent docs. Keep mutually exclusive coverage totals: reviewed unchanged, edited, deferred/skipped with reason, and unreadable/unreviewed. Identify uncovered groups compactly; give exact path lists only when useful and manageable, otherwise offer a bounded continuation. Focused arguments can defer lower-priority batches but never justify claiming full-repository cleanup.

## Review by document type

Across documents, assess factual support, clarity, audience fit, ownership, duplication, headings/frontmatter/fences, local links and anchors, and navigation. Check inbound as well as outbound links before any approved move or rename. Use existing navigation, indexes, routes, redirects, includes, and canonical-source conventions. Add meaningful cross-links where they help readers move between related material; avoid all-to-all links and bare link substitutions without understanding their context. External URLs are not validated unless actually checked; report that limitation.

Distinguish what is proposed or intended from what is implemented today and what has been verified. Compare claims with authoritative source/docs or evidence, but do not make documentation agree with broken, insecure, or surprising code merely because it exists. Do not silently promote plans into current behavior or mark them stale based only on age. Preserve historical rationale and material differences among packages, audiences, languages, and versions. Repeated examples may be necessary for standalone usability; consolidate genuinely duplicated normative instructions, not every similar explanation.

Apply type-appropriate meaning of “clean”:

- **Entry points and onboarding:** clarify who the doc is for, prerequisites, supported package/project scope, first successful path, and links to deeper guidance. Distinguish root README responsibilities from package READMEs in a monorepo; do not impose a new hierarchy.
- **Tutorials and how-to guides:** make prerequisites and steps coherent and ordered, and ensure examples are understandable and reproducible from evidence. Keep tutorials task-oriented rather than turning them into exhaustive reference.
- **API, CLI, schema, and configuration reference:** check names, parameters, defaults, units, authentication, compatibility, and version parity against authoritative source evidence. Static review is fine; do not execute commands just to prove reference text.
- **Architecture and decisions:** explain system boundaries and rationale where supported. Keep ADR history intact; clarify status and explicit supersession links without rewriting historical decisions as current truth.
- **RFCs, specifications, plans, and proposals:** label intent, status, owner, and completion evidence when known. Do not infer completion, abandonment, or staleness from age alone; ask about conflicting status claims.
- **Runbooks and operations:** check prerequisites, impact, required permissions, safe health checks, rollback/recovery, and secret-safe examples. Report missing operational detail rather than inventing it. Never run deploy, destructive, recovery, authentication, or billable operations to verify docs.
- **Releases, migrations, and versioned/archived docs:** preserve release and compatibility traceability, deprecation status, and history. Label applicability and supersession; do not flatten distinct versions or delete old material just because a newer version exists.
- **Security, legal, and compliance claims:** preserve disclosure, license, legal meaning, and security-sensitive material. Escalate semantic edits for authoritative human review; do not simplify away required warnings or claims.
- **Localization:** preserve translation meaning and ownership. Similar prose across languages is not proof of duplicate or stale content; do not machine-normalize or rewrite translations as ordinary copy edits.
- **Generated reference, MDX, and docs-site content:** edit the authoritative source and regenerate only through an established, approved documented workflow. Preserve frontmatter schemas, JSX/components and imports, directives, templates, fenced examples, literal fixture/example Markdown, site-specific routes/anchors, includes, redirects, and build/navigation semantics. If regeneration is not authorized or cannot be checked, report generated outputs as unverified rather than hand-editing them as if canonical.

## Ownership, conflicts, and changes

For each important claim or instruction, identify one authoritative owner where appropriate: a shared project fact, role contract, reusable procedure, product/API source, release record, or legal/security authority. Link to canonical material instead of maintaining conflicting copies. Keep distinctions in scope, version, language, rationale, or audience when they are intentional. When two credible authoritative sources conflict, gather the concrete claims and paths and ask the human; do not choose a winner silently.

Agent context separation is one example of this ownership model, not the purpose of repository cleanup: shared project facts belong in applicable `AGENTS.md`, role-specific behavior belongs in that role's prompt, and reusable procedures belong in commands or skills. Do not add or require a relationship overview just because related material exists; human navigation and agent-loaded context are different. In this template, route creation, editing, or retirement of agent definitions, explicitly assigned OpenCode command/skill instruction assets (including assigned instructional references/templates), and assigned `AGENTS.md` instruction maintenance exclusively to `agent-maintainer`; do not read every agent prompt or send those files to a general documentation worker. A general documentation worker may own the remaining documentation cleanup work; executable support scripts remain implementation work, and configuration/runtime integration remains with Design. Design coordinates non-overlapping assignments; if the specialist is unavailable, report the affected instruction-maintenance portion blocked rather than use a fallback owner. Preserve complementary handoff rules, safety, approvals, permissions, model configuration, goal/proof semantics, and applicable source-versus-destination distribution boundaries.

Preserve historical decisions, changelog/release records, legal text, and security disclosures. Do not bulk-delete or bulk-move documentation, invent facts/examples/verification, fill template placeholders, rebaseline goal/status/proof records, or create a parallel documentation system. If a move is approved, check all inbound links, route/anchor behavior, redirects, indexes, and references before changing it. Keep the patch scoped; leave uncertain semantic changes for a human decision. On reruns, keep already-clear prose and correct links unchanged; do not recreate an equivalent overview or churn wording, links, or structure without a concrete reason.

## Validation and report

Select existing, relevant validation entrypoints based on changed file types: for example local link/anchor checks, docs-site or Markdown lint/build checks, schema/frontmatter validation, or established example checks. Use the appropriate tester for test execution and corrections; do not install tools, initiate network crawls, or run arbitrary commands to manufacture validation. Do not execute deployment, destructive, authentication, or billable workflows. For generated content, use only the documented approved generation path. If no suitable check is established, say so. Keep validation claims distinct: static source review, link checks, docs build, example execution, and product behavior prove different things.

Follow applicable repository verification policy and use established checks appropriate to the changes. Do not create a test harness, tracking system, or other persistent artifacts unless requested.

Finish with a concise report of:

- changed paths and the canonical ownership decisions made;
- inventory scope, classification summary, mutually exclusive coverage totals, exclusions, and uncovered groups/paths;
- conflicts escalated and unresolved semantic or ownership questions;
- relevant validation commands and exact outcomes when run by the authorized owner, plus checks not run and why;
- generated outputs or external links that remain unverified and other material risks.

Do not claim all docs are clean when batches remain deferred, imply external links work without checking them, or present a static review as execution or behavioral proof.
