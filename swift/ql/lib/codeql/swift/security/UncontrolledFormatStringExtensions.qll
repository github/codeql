/**
 * Provides classes and predicates for reasoning about uncontrolled
 * format string vulnerabilities.
 */

import swift
private import codeql.swift.StringFormat
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.TaintTracking
private import codeql.swift.dataflow.ExternalFlow

/**
 * A dataflow sink for uncontrolled format string vulnerabilities.
 */
abstract class UncontrolledFormatStringSink extends DataFlow::Node { }

/**
 * A barrier for uncontrolled format string vulnerabilities.
 */
abstract class UncontrolledFormatStringBarrier extends DataFlow::Node { }

/**
 * A unit class for adding additional flow steps.
 */
class UncontrolledFormatStringAdditionalFlowStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a flow
   * step for paths related to uncontrolled format string vulnerabilities.
   */
  abstract predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo);
}

/**
 * A default uncontrolled format string sink.
 */
private class DefaultUncontrolledFormatStringSink extends UncontrolledFormatStringSink {
  DefaultUncontrolledFormatStringSink() {
    // the format argument to a `FormattingFunctionCall`.
    this.asExpr() = any(FormattingFunctionCall fc).getFormat()
    or
    // a sink defined in a CSV model.
    sinkNode(this, "format-string")
  }
}
