# Product Proof Inventory

This seed is intentionally empty. Add entries only after inspecting the project's tests and runners and after human approval of the relevant goals. Never invent evidence, commands, dependencies, environments, or qualification.

An `e2e` test exercises production implementations and every required service boundary in a local, CI, staging, or deployed production environment; it may not replace a required dependency with a fake or mock. Record descriptive project test kinds separately from E2E qualification. Other tests may use doubles and provide supporting regression evidence. By default, every leaf goal requires multiple independent automated tests, including at least one qualifying e2e test. Independence means distinct meaningful failure coverage, not renamed duplicates; a suite can support multiple leaves only where it asserts each outcome.

Use exact stable test IDs or exact Playwright titles. For Playwright entries, record the exact command; use a path only when needed to disambiguate an otherwise stable ID or title. Record prerequisite creation and cleanup ownership. Proof must demonstrate a product outcome, not merely an endpoint response or component render.

This inventory owns reusable coverage/qualification contracts and gaps, not latest pass/fail status or run history. Prefer canonical runner, environment, and setup references over repeated instructions. Update relevant selectors, coverage, and boundaries when they change; leave accurate entries alone for implementation-only refactors.

Distinguish discovered tests and qualification by inspection from applicable successful execution evidence in existing task, CI, or report systems. `done` requires both qualifying coverage and applicable successful results for all remaining required independent proof after any explicit goal-scoped exemption; known outcome defects or remaining required relevant failures cannot justify it. Reassess applicability after relevant implementation, test, dependency, or environment changes, without arbitrary expiry or automatic per-commit downgrade. Reusable manual procedures may be linked as supporting checks, but dated manual results do not satisfy required automated E2E proof.

Follow [user-waiver scope rules](../SKILL.md#user-waivers). Record only explicit goal-scoped policy exemptions here: concise scope, specific requirements exempted, and user rationale if supplied, alongside the affected mappings. Keep task-only waivers in task/final reports. An exemption is not a passed test and does not erase unrelated gaps.

| Goal | Exact test ID(s) or suite | Asserted outcome / failure coverage | Exact command / selector | Project test kind | E2E qualification / boundary gaps | Environment assumptions | Prerequisite creation owner | Cleanup owner | Dependencies | Coverage gaps |
|---|---|---|---|---|---|---|---|---|---|---|

If proof relies on an A=>B=>C decomposition, inventory the transition suites and intermediate identity and contract. Keep independent library inventories separate.
