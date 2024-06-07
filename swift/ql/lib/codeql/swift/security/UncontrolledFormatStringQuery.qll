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
module TaintedFormatConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof FlowSource }

  predicate isSink(DataFlow::Node node) { node instanceof UncontrolledFormatStringSink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof UncontrolledFormatStringBarrier }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(UncontrolledFormatStringAdditionalFlowStep s).step(nodeFrom, nodeTo)
  }
}

/**
 * Detect taint flow of tainted data that reaches a format string.
 */
module TaintedFormatFlow = TaintTracking::Global<TaintedFormatConfig>;
