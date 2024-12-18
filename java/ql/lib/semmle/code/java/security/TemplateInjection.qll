/** Definitions related to the server-side template injection (SST) query. */

import java
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.security.Sanitizers

/**
 * A source for server-side template injection (SST) vulnerabilities.
 */
abstract class TemplateInjectionSource extends DataFlow::Node { }

/**
 * A sink for server-side template injection (SST) vulnerabilities.
 */
abstract class TemplateInjectionSink extends DataFlow::Node { }

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
}

/**
 * A sanitizer for server-side template injection (SST) vulnerabilities.
 */
abstract class TemplateInjectionSanitizer extends DataFlow::Node { }

private class DefaultTemplateInjectionSource extends TemplateInjectionSource instanceof ActiveThreatModelSource
{ }

private class DefaultTemplateInjectionSink extends TemplateInjectionSink {
  DefaultTemplateInjectionSink() { sinkNode(this, "template-injection") }
}

private class DefaultTemplateInjectionSanitizer extends TemplateInjectionSanitizer instanceof SimpleTypeSanitizer
{ }
