/**
 * Provides classes and predicates for detecting prompt injection vulnerabilities
 * in GitHub Actions workflows that use AI inference actions.
 *
 * This library identifies:
 * - CWE-1427: User-controlled data flowing into AI model prompts without sanitization
 */

private import actions
private import codeql.actions.TaintTracking
private import codeql.actions.dataflow.ExternalFlow
import codeql.actions.dataflow.FlowSources
import codeql.actions.DataFlow
import codeql.actions.security.ControlChecks

/**
 * A sink for prompt injection vulnerabilities (CWE-1427).
 * Defined entirely through MaD extensible `actionsSinkModel` with kind `prompt-injection`.
 */
class PromptInjectionSink extends DataFlow::Node {
  PromptInjectionSink() { madSink(this, "prompt-injection") }
}

/**
 * A source representing user-controlled data from repository_dispatch client_payload.
 * The client_payload can be set by anyone with write access to the repository
 * or via the GitHub API, making it a potential vector for injection attacks.
 */
class RepositoryDispatchClientPayloadSource extends RemoteFlowSource {
  string event;

  RepositoryDispatchClientPayloadSource() {
    exists(Expression e |
      this.asExpr() = e and
      e.getExpression().matches("github.event.client_payload%") and
      event = e.getATriggerEvent().getName() and
      event = "repository_dispatch"
    )
  }

  override string getSourceType() { result = "client_payload" }

  override string getEventName() { result = event }
}

/**
 * Gets the relevant event for a sink in a privileged context,
 * excluding sinks protected by control checks for the prompt-injection category.
 */
Event getRelevantEventForSink(DataFlow::Node sink) {
  inPrivilegedContext(sink.asExpr(), result) and
  not exists(ControlCheck check | check.protects(sink.asExpr(), result, "prompt-injection"))
}

/**
 * Gets the relevant event for a prompt injection sink, including
 * repository_dispatch events which are externally triggerable via the GitHub API.
 */
Event getRelevantEventForPromptInjection(DataFlow::Node sink) {
  result = getRelevantEventForSink(sink)
  or
  exists(LocalJob job |
    job = sink.asExpr().getEnclosingJob() and
    job.getATriggerEvent() = result and
    result.getName() = "repository_dispatch"
  )
}

/**
 * Holds when a critical-severity prompt injection path exists from source to sink.
 */
predicate criticalSeverityPromptInjection(
  PromptInjectionFlow::PathNode source, PromptInjectionFlow::PathNode sink, Event event
) {
  PromptInjectionFlow::flowPath(source, sink) and
  event = getRelevantEventForPromptInjection(sink.getNode()) and
  source.getNode().(RemoteFlowSource).getEventName() = event.getName()
}

/**
 * Gets the relevant event for a sink in any externally triggerable context,
 * excluding sinks protected by control checks for the prompt-injection category.
 * This is broader than `getRelevantEventForSink` — it includes non-privileged
 * events like `pull_request` where an attacker can still control event properties
 * (PR title, body, branch name) that flow into AI prompts.
 */
Event getRelevantEventForMediumSeverity(DataFlow::Node sink) {
  exists(LocalJob job |
    job = sink.asExpr().getEnclosingJob() and
    job.getATriggerEvent() = result and
    result.isExternallyTriggerable() and
    not inPrivilegedContext(sink.asExpr(), result) and
    not result.getName() = "repository_dispatch" and
    not exists(ControlCheck check | check.protects(sink.asExpr(), result, "prompt-injection"))
  )
}

/**
 * Holds when a medium-severity prompt injection path exists from source to sink.
 * Covers non-privileged but externally triggerable events (e.g. pull_request)
 * where an attacker can control event properties that flow into AI prompts.
 */
predicate mediumSeverityPromptInjection(
  PromptInjectionFlow::PathNode source, PromptInjectionFlow::PathNode sink, Event event
) {
  PromptInjectionFlow::flowPath(source, sink) and
  event = getRelevantEventForMediumSeverity(sink.getNode()) and
  source.getNode().(RemoteFlowSource).getEventName() = event.getName()
}

/**
 * A taint-tracking configuration for unsafe user input
 * that is used to construct AI prompts (CWE-1427).
 */
private module PromptInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof PromptInjectionSink }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    result = sink.getLocation()
    or
    result = getRelevantEventForPromptInjection(sink).getLocation()
  }
}

/** Tracks flow of unsafe user input that is used to construct AI prompts. */
module PromptInjectionFlow = TaintTracking::Global<PromptInjectionConfig>;
