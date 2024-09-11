/** Definitions related to the server-side template injection (SST) query. */

import java
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.security.Sanitizers

/**
 * A source for server-side template injection (SST) vulnerabilities.
 */
abstract class TemplateInjectionSource extends DataFlow::Node {
  /**
   * DEPRECATED: Open-ended flow state is not intended to be part of the extension points.
   *
   * Holds if this source has the specified `state`.
   */
  deprecated predicate hasState(DataFlow::FlowState state) {
    state instanceof DataFlow::FlowStateEmpty
  }
}

/**
 * A sink for server-side template injection (SST) vulnerabilities.
 */
abstract class TemplateInjectionSink extends DataFlow::Node {
  /**
   * DEPRECATED: Open-ended flow state is not intended to be part of the extension points.
   *
   * Holds if this sink has the specified `state`.
   */
  deprecated predicate hasState(DataFlow::FlowState state) {
    state instanceof DataFlow::FlowStateEmpty
  }
}

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to flows related to
 * server-side template injection (SST) vulnerabilities.
 */
class TemplateInjectionAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for flows related to server-side template injection (SST) vulnerabilities.
   */
  predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) { none() }

  /**
   * DEPRECATED: Open-ended flow state is not intended to be part of the extension points.
   *
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for flows related toserver-side template injection (SST) vulnerabilities.
   * This step is only applicable in `state1` and updates the flow state to `state2`.
   */
  deprecated predicate isAdditionalTaintStep(
    DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
    DataFlow::FlowState state2
  ) {
    none()
  }
}

/**
 * A sanitizer for server-side template injection (SST) vulnerabilities.
 */
abstract class TemplateInjectionSanitizer extends DataFlow::Node { }

/**
 * DEPRECATED: Open-ended flow state is not intended to be part of the extension points.
 *
 * A sanitizer for server-side template injection (SST) vulnerabilities.
 * This sanitizer is only applicable when `TemplateInjectionSanitizerWithState::hasState`
 * holds for the flow state.
 */
abstract deprecated class TemplateInjectionSanitizerWithState extends DataFlow::Node {
  /**
   * DEPRECATED: Open-ended flow state is not intended to be part of the extension points.
   *
   * Holds if this sanitizer has the specified `state`.
   */
  abstract deprecated predicate hasState(DataFlow::FlowState state);
}

private class DefaultTemplateInjectionSource extends TemplateInjectionSource instanceof ThreatModelFlowSource
{ }

private class DefaultTemplateInjectionSink extends TemplateInjectionSink {
  DefaultTemplateInjectionSink() { sinkNode(this, "template-injection") }
}

private class DefaultTemplateInjectionSanitizer extends TemplateInjectionSanitizer instanceof SimpleTypeSanitizer
{ }
