/**
 * Provides classes and predicates for reasoning about uncontrolled
 * format string vulnerabilities.
 */

import swift
import codeql.swift.StringFormat
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking

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
 * A default uncontrolled format string sink, that is, the format argument to
 * a `FormattingFunctionCall`.
 */
private class DefaultUncontrolledFormatStringSink extends UncontrolledFormatStringSink {
  DefaultUncontrolledFormatStringSink() {
    this.asExpr() = any(FormattingFunctionCall fc).getFormat()
  }
}
