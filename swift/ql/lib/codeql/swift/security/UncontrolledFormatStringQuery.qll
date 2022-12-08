/**
 * Provides a taint-tracking configuration for reasoning about uncontrolled
 * format string vulnerabilities.
 */

import swift
import codeql.swift.StringFormat
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.dataflow.FlowSources
import codeql.swift.security.UncontrolledFormatStringExtensions

/**
 * A taint configuration for tainted data that reaches a format string.
 */
class TaintedFormatConfiguration extends TaintTracking::Configuration {
  TaintedFormatConfiguration() { this = "TaintedFormatConfiguration" }

  override predicate isSource(DataFlow::Node node) { node instanceof FlowSource }

  override predicate isSink(DataFlow::Node node) { node instanceof UncontrolledFormatStringSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof UncontrolledFormatStringSanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(UncontrolledFormatStringAdditionalTaintStep s).step(nodeFrom, nodeTo)
  }
}
