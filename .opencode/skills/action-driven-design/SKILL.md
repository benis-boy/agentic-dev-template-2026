---
name: action-driven-design
description: Action-driven design and *-feature.md plans. Use when defining, changing, implementing, or reviewing user actions, interaction workflows, action overlap, or feature plans organized around what a user can do.
---

# Action-Driven Design

Use the product's `*-feature.md` file as the design record for work centered on user or operator actions.

## Workflow

1. Find the relevant `*-feature.md` plan before proposing or implementing behavior. Create one when the feature has no plan.
2. Identify each action by its user intent, trigger, context, observable result, system activity, failure/recovery behavior, and tests.
3. Mark sections being changed as **In progress** while work is underway. Remove the marker when the section accurately describes the implemented product.
4. Keep the plan synchronized throughout implementation. At completion it describes the product's current behavior, rather than a chronology of superseded behavior.
5. Keep a glossary in the plan for feature-specific concepts, states, and terms.

## Action Definition

Explain every action with enough context that a reader can understand:

- why the action exists and the user goal it serves;
- where and when it is available;
- how the user invokes it, including relevant keyboard behavior;
- what changes immediately in the interface;
- what system request, processing, persistence, or authoritative refresh it causes;
- what success, pending, failure, and recovery look like;
- which automated tests prove those results.

Describe the current affirmative behavior. Do not preserve historical scope by listing behavior an action no longer performs.

## Ambiguity and Overlap

Ask the user for clarification before design or implementation when:

- it is unclear which existing action they want adjusted; or
- a proposed action meaningfully overlaps an existing action in intent, effect, or system activity.

Name the overlapping actions and state the ambiguity in the question. Do not silently choose between plausible meanings. Similar actions that remain in the product must have their distinct purposes and effects explained in the plan.

## Test Requirements

- Every action must link to automated tests proving its expected result.
- Cover the action's meaningful success, failure, and recovery outcomes, not only that its control renders.
- An action that depends on integrated system behavior or authoritative data availability requires an end-to-end test against the real system.
- End-to-end tests must clean up every resource they create, including on failure.
- Presentation-only behavior may use focused component or browser tests when no integrated system result is involved.
- Treat missing required proof as unfinished feature work and mark it clearly in the plan.

## Delegation

When assigning implementation to a coding subagent, cite the relevant plan sections as file references, for example `docs/example-feature.md#apply-a-suggestion`. Include the action's expected result, system activity, and required test level in the assignment. Require the subagent to update its owned plan sections as part of the same change.

## Completion Check

Before declaring the work complete, verify that:

- no section remains marked **In progress**;
- action explanations, system activity, and implementation agree;
- overlapping actions have a clear distinction;
- every action has the required passing proof, including self-cleaning end-to-end coverage where integration-dependent;
- the glossary defines every feature-specific term needed to understand the actions.
