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
 * A sanitizer for uncontrolled format string vulnerabilities.
 */
abstract class UncontrolledFormatStringSanitizer extends DataFlow::Node { }

/**
 * A unit class for adding additional taint steps.
 */
class UncontrolledFormatStringAdditionalTaintStep extends Unit {
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
    sinkNode(this, "uncontrolled-format-string")
  }
}
