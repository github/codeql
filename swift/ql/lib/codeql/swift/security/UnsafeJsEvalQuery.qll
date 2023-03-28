/**
 * Provides a taint-tracking configuration for reasoning about javascript
 * evaluation vulnerabilities.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.dataflow.FlowSources
import codeql.swift.security.UnsafeJsEvalExtensions

/**
 * A taint configuration from taint sources to sinks for this query.
 */
class UnsafeJsEvalConfig extends TaintTracking::Configuration {
  UnsafeJsEvalConfig() { this = "UnsafeJsEvalConfig" }

  override predicate isSource(DataFlow::Node node) { node instanceof FlowSource }

  override predicate isSink(DataFlow::Node node) { node instanceof UnsafeJsEvalSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof UnsafeJsEvalSanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(UnsafeJsEvalAdditionalTaintStep s).step(nodeFrom, nodeTo)
  }
}
