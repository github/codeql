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
module UnsafeJsEvalConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof FlowSource }

  predicate isSink(DataFlow::Node node) { node instanceof UnsafeJsEvalSink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof UnsafeJsEvalBarrier }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(UnsafeJsEvalAdditionalFlowStep s).step(nodeFrom, nodeTo)
  }
}

/**
 * Detect taint flow of taint sources to sinks for this query.
 */
module UnsafeJsEvalFlow = TaintTracking::Global<UnsafeJsEvalConfig>;
