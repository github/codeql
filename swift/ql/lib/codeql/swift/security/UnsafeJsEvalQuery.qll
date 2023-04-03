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
deprecated class UnsafeJsEvalConfig extends TaintTracking::Configuration {
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

/**
 * A taint configuration from taint sources to sinks for this query.
 */
module UnsafeJsEvalConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof FlowSource }

  predicate isSink(DataFlow::Node node) { node instanceof UnsafeJsEvalSink }

  predicate isBarrier(DataFlow::Node sanitizer) { sanitizer instanceof UnsafeJsEvalSanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(UnsafeJsEvalAdditionalTaintStep s).step(nodeFrom, nodeTo)
  }
}

/**
 * Detect taint flow of taint sources to sinks for this query.
 */
module UnsafeJsEvalFlow = TaintTracking::Global<UnsafeJsEvalConfig>;
