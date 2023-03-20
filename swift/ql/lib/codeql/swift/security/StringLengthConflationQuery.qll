/**
 * Provides a taint-tracking configuration for reasoning about string length
 * conflation vulnerabilities.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.security.StringLengthConflationExtensions

/**
 * A configuration for tracking string lengths originating from source that is
 * a `String` or an `NSString` object, to a sink of a different kind that
 * expects an incompatible measure of length.
 */
class StringLengthConflationConfiguration extends TaintTracking::Configuration {
  StringLengthConflationConfiguration() { this = "StringLengthConflationConfiguration" }

  override predicate isSource(DataFlow::Node node, string flowstate) {
    flowstate = node.(StringLengthConflationSource).getStringType()
  }

  override predicate isSink(DataFlow::Node node, string flowstate) {
    // Permit any *incorrect* flowstate, as those are the results the query
    // should report.
    exists(string correctFlowState |
      correctFlowState = node.(StringLengthConflationSink).getCorrectStringType() and
      flowstate.(StringType).getEquivClass() != correctFlowState.(StringType).getEquivClass()
    )
  }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof StringLengthConflationSanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(StringLengthConflationAdditionalTaintStep s).step(nodeFrom, nodeTo)
  }
}
