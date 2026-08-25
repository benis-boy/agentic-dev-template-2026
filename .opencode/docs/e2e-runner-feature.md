# End-to-End Runner

This document defines a prospective, generalized end-to-end runner for
{{projectPlaceholder}}. It is an implementation plan, not a claim that the
runner exists. The implementing project must choose its suites, commands,
platform integration, and test framework at the marked customization points.

## Run test suites

### Run the default end-to-end set

**Purpose and use.** The default invocation of {{projectPlaceholder}} will run
the project's default end-to-end suites in a deterministic order, print each
invoked command, stream useful progress, and end with an unambiguous result.

**Required behavior.** The runner will select each default suite once, perform
shared platform readiness once, provide resolved endpoint aliases to child
processes, discover cases, and invoke one process per case. The default suite
set and entrypoint are {{projectPlaceholder}}.

**Required proof.** Tests must verify default selection, ordering, command
construction, shared readiness, environment composition, and final status.

### Select, order, and deduplicate suites

**Purpose and use.** Repeatable `--suite {{projectPlaceholder}}` options will
run only requested suites. The first occurrence determines order and duplicate
selections will not run twice. Invalid names will fail during argument parsing
without platform activity.

**Required behavior.** Every selected live suite will require the same complete
shared readiness set; readiness will not be reduced based on suite selection.
One-shot or non-serving platform tasks must be excluded from HTTP readiness.
The accepted suite names and their order are {{projectPlaceholder}}.

**Required proof.** Parameterized tests must cover no selection, each
individual suite, reversed order, duplicates, and invalid values.

### Focus backend or service tests

**Purpose and use.** A project-specific focused selector will allow one test or
subtest to run without unrelated suites when paired with its suite selection.
The selector syntax is {{projectPlaceholder}}.

**Required behavior.** Discovery will use the selected framework's listing
mechanism {{projectPlaceholder}}. Each discovered top-level name will run
exactly once with an exact, safely escaped selector and the configured
per-test timeout. Discovery and execution commands must be constructed as
structured argument vectors, not unsafe shell strings.

**Required proof.** Tests must prove filtered and unfiltered arguments exactly,
including spaces and selector metacharacters.

### Focus frontend or other targeted tests

**Purpose and use.** Repeatable target values will pass file, line, project, or
title-level focus through to the applicable suite. Targets will retain caller
order. The target format and suite adapter are {{projectPlaceholder}}.

**Required behavior.** Discovery will use the framework-local listing facility
{{projectPlaceholder}}. Each case will run independently with an exact target,
the requested project or equivalent disambiguator, exactly one worker, and a
configured timeout. Failed reruns will use stable source selectors rather
than display-only identifiers. Any one-time setup, such as installing a test
dependency, will not repeat for every case.

**Required proof.** Tests must prove target arguments, realistic listing
parsing, disambiguation, target order, and exact rerun selectors. A focused
live check must prove that a named target is honored.

### Configure separate timeouts

**Purpose and use.** `--timeout <seconds>` will be the per-test execution
timeout, independently restarted for every discovered case.
`--readiness-timeout <seconds>` will bound the single shared readiness pass.
Their project defaults are {{projectPlaceholder}}.

**Required behavior.** Non-positive values will be rejected before platform
activity, and diagnostics will identify which phase exhausted its timeout. The
outer per-process deadline will remain authoritative even if a test framework
has its own setting. No timeout will span a suite.

**Required proof.** Tests must cover defaults, custom values, invalid values,
phase-specific timeout messages, and the fact that each test gets a fresh
deadline.

### Continue on failure or fail fast

**Purpose and use.** Independent targeted tests will continue after a failure
by default so one invocation yields all available results. `--fail-fast` will
opt into stopping immediately after the first failed test.

**Required behavior.** Without the flag, every later target starts and every
failure and trace is retained. With it, no later target starts after the first
failure. Readiness failure and interruption will always stop the run because
subsequent tests cannot execute reliably.

**Required proof.** Tests must cover default continuation, multiple retained
failures, fail-fast termination, readiness failure, and interruption.

### Retain traces

**Purpose and use.** `--retain-trace-on-success` will preserve successful test
traces when detailed evidence is needed. Failed and interrupted traces will
always be retained.

**Required behavior.** The option will default to false. Without it, the
runner will delete a successful test's trace directory after completion. It
will never delete a failed or interrupted trace. Cleanup failures will be
reported without changing the test status.

**Required proof.** Tests must cover default successful deletion, explicit
retention, unconditional failure retention, and cleanup failure isolation.

## Synchronize with the local platform

### Wait for source reconciliation

**Purpose and use.** Before any selected live suite starts, the runner will
wait for the project's source watcher or equivalent to finish reconciling
saved changes, preventing races with stale services.

**Required behavior.** The status and trigger interfaces are
{{projectPlaceholder}}. An active idle state will be ready. A waiting debounce
may be triggered at most once per waiting interval; the runner will then poll
until idle. Invalid payloads, inactive state, connection failures, and timeout
will produce concise phase-specific failures.

**Required proof.** Tests must cover idle, waiting-trigger-progress-idle,
repeated waiting, renewed waiting, inactive status, malformed payloads,
transient request errors, and timeout details.

### Resolve authoritative endpoints

**Purpose and use.** Tests will receive deterministic host-reachable URLs from
the platform's authoritative resolver rather than guessing network addresses.

**Required behavior.** The resolver and resolution mode are
{{projectPlaceholder}}. The runner will select the complete shared endpoint
set for every live suite and merge declared aliases into a copy of the caller
environment. Repeated aliases with the same value will be deduplicated;
conflicting values for one alias will fail deterministically. Missing required
published endpoints will fail before a suite starts. The topology source of
truth is {{projectPlaceholder}}.

**Required proof.** Tests must cover suite-to-endpoint mapping, stable
deduplication, missing endpoints, alias merging, preservation of caller
variables, and deterministic conflict handling.

### Verify HTTP readiness

**Purpose and use.** Every required serving component must be reachable before
tests begin, with actionable identification of the component and URL that did
not become ready.

**Required behavior.** Each unique required probe will be checked once after
source reconciliation. A final HTTP status from 200 through 499 will count as
reachable; statuses 500 and above will not. Redirects may be followed, but
only the final response status will be evaluated. Redirect loops and
unfollowable redirects are not ready. Each request timeout will be no greater
than five seconds or the remaining overall deadline, whichever is smaller.

**Required proof.** Tests must cover the 200 and 499 boundaries, 500 rejection,
successful redirects, redirect failure, DNS/connect failures, request
timeouts, eventual success, probe deduplication, and deadline exhaustion.

## Execute and report

### Print concise live status

**Purpose and use.** Developers will see useful progress in real time without
scanning the complete raw test stream.

**Required behavior.** A status component will write directly to stdout. At
test start it will identify the test ID, suite, command, and effective target
parameters. It will consume output continuously without deadlock or unbounded
buffering, emit only useful current lines, and warn once when a test has run
for the configured long-running threshold {{projectPlaceholder}}. Output will
remain readable when redirected or when color is disabled. Filtering affects
only live output and never the execution trace.

**Required proof.** Tests must cover start status and parameters, useful-line
selection, noisy-line suppression, redirected and color-disabled output, the
one-time warning, and subprocess completion. An integration test must exercise
interleaved child output while proving the complete stream remains in the
trace.

### Trace each test execution

**Purpose and use.** Every targeted test will have a complete debugging record
independent of concise stdout presentation.

**Required behavior.** Before each test starts, the runner will create
`{{projectPlaceholder}}/{test-slug}/`. The slug will be deterministic,
filesystem-safe, and collision-safe within a run. The directory will record
argv, effective targeting parameters, timing, exit status, and as much raw
stdout and stderr as can be captured without risking child-process deadlock.
Collection starts before launch and finalizes on success, failure, timeout, or
interruption. These traces are separate from resource diagnostics.

**Required proof.** Tests must cover slug generation and collisions, metadata,
complete stdout/stderr capture, finalization on every exit path, retention,
and independence from resource diagnostics. Process-level tests must prove
large and interleaved output is captured without deadlock.

### Report results and summarize failures

**Purpose and use.** Immediate results will stay brief while the end-of-run
summary provides everything needed to investigate and rerun failures.

**Required behavior.** A success will print only `SUCCESS <test-id>`. A failure
will initially print `FAILED <test-id>: <shortest useful error>`; detail stays
in its trace. If any test failed, one deterministic overview will list failed
IDs, concise errors, exact commands to rerun each, trace locations, and a brief
parameter overview equivalent in content to `--help`. Raw output will not be
repeated. A fully successful run will have no expanded summary.

Overall success returns `0`, any test, runner, or readiness failure returns
`1`, and keyboard interruption returns `130`. Cleanup, tracing, and diagnostic
failures are reported but never replace the primary status.

**Required proof.** Tests must cover exact result lines, shortest-error
selection, continued execution, fail-fast behavior, failure ordering, safely
quoted focused rerun commands, trace paths, help-equivalent parameters, the
absence of an expanded success summary, and every exit class.

### Handle interruption and child processes

**Purpose and use.** Interruption will promptly stop the active suite without
leaving descendants running.

**Required behavior.** The runner will forward termination to the whole child
process group, wait a bounded grace period, escalate to group kill even if the
leader exits while descendants hold pipes, close streams, and never
indefinitely join drain threads. This must work for every suite adapter.

**Required proof.** Process-level tests will use disposable child commands to
prove cooperative termination and forced-kill paths without touching the local
platform.

## Preserve diagnostics

### Capture best-effort resource evidence

**Purpose and use.** Each invocation will record available platform and host
resource evidence to investigate resource-related failures without changing
the test result.

**Required behavior.** The runner will create a unique directory beneath
`{{projectPlaceholder}}`, record run metadata, sample platform resource data
during execution, and finalize platform state, container/process inspection,
and accessible memory counters. Every diagnostic command and write will be
timeout-bounded and best effort. Setup, sampling, or finalization failure will
be reported but never mask the primary exit status.

**Required proof.** Tests using temporary directories and fake command results
must cover naming, metadata, repeated samples, finalization, malformed inspect
output, unavailable resource counters, and failure isolation. No test may
depend on a real platform daemon.

## Maintain quality and testability

### Keep orchestration boundaries independently testable

**Purpose and use.** Suite selection, command creation, watcher interpretation,
endpoint selection, readiness policy, process execution, reporting, and
diagnostics must be verifiable without a live platform.

**Required behavior.** Side effects will remain behind explicit functions or
collaborators. Argument parsing will accept injectable arguments; time, HTTP,
subprocess, endpoint, filesystem, watcher, and diagnostic boundaries will be
replaceable in tests. Importing the runner will perform no platform or
filesystem activity.

**Required proof.** The independent regression suite will use the project's
test tooling {{projectPlaceholder}} and perform no network, platform, watcher,
browser, package-manager, or service operations.

### Document adoption

**Purpose and use.** Maintainers will be able to make the planned behavior
canonical without leaving conflicting instructions.

**Required behavior.** The adoption change will update the project's agent
guidance, README, test strategy, feature-plan command references, and relevant
diagnostics documentation at {{projectPlaceholder}}. It will identify one
canonical entrypoint and document focused, full, failure-rerun, and
non-interactive usage.

**Required proof.** Repository search must find no stale canonical command,
and focused and full examples must pass through the adopted entrypoint.

## Required verification before adoption

- Runner regression: {{projectPlaceholder}}
- Focused service or backend proof: {{projectPlaceholder}}
- Focused UI or other target proof: {{projectPlaceholder}}
- Full end-to-end proof: {{projectPlaceholder}}
- Repository lint and static checks: {{projectPlaceholder}}
- Unit and process-boundary proof must not require a live platform.

## Extension checklist

Before implementation, add or refine requirements here for:

- additional suites or suite aliases;
- concurrency versus deterministic sequential execution;
- retries or sharding;
- machine-readable reports and summaries;
- color, verbosity, quiet mode, and CI/non-interactive behavior;
- cleanup policy and retained test data;
- platform preflight scope and environment-failure messaging;
- duration reporting, slow-test reporting, and performance budgets;
- future entrypoint or policy changes.

## Glossary

- **Caller environment:** Environment inherited when the runner starts, copied
  before endpoint aliases are added.
- **Endpoint alias:** A service URL variable emitted by the authoritative
  endpoint resolver for child test processes.
- **Live suite:** A suite that requires services from the local platform.
- **Platform readiness:** Source reconciliation, endpoint resolution, and HTTP
  reachability completed before a live suite starts.
- **Primary status:** The exit result caused by test execution, readiness
  failure, or interruption; diagnostics cannot replace it.
- **Probe:** A named HTTP URL used to establish service readiness.
- **Resource diagnostics:** Best-effort run and platform evidence stored apart
  from per-test execution traces.
- **Suite target:** A discovery filter supplied by the caller and expanded into
  individual test targets.
- **Per-test timeout:** The independently restarted process deadline for each
  discovered test.
- **Readiness timeout:** The single shared deadline for reconciliation and HTTP
  probes.
- **Test ID:** Stable identifier printed in status and summaries and used to
  construct a focused rerun command.
- **Test slug:** Filesystem-safe, collision-safe representation of a test ID
  used beneath the trace directory.
- **Test trace:** Per-test command, parameters, timing, status, and maximally
  captured process output retained for debugging.

## Explicit non-features

- Repeat execution is not supported; each targeted test executes exactly once
  per runner invocation.
- Skipping readiness is not supported; readiness is mandatory for every live
  suite.
- Implicit endpoint guessing is not supported; required endpoints must come
  from the authoritative resolver.
- Live output is not a substitute for complete per-test traces.
- Diagnostic failure does not change the primary test result.
