/**
 * Provides a taint-tracking configuration for reasoning about database
 * queries built from user-controlled sources (that is, SQL injection
 * vulnerabilities).
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.dataflow.FlowSources
import codeql.swift.security.SqlInjectionExtensions

/**
 * A taint configuration for tainted data that reaches a SQL sink.
 */
module SqlInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof FlowSource }

  predicate isSink(DataFlow::Node node) { node instanceof SqlInjectionSink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof SqlInjectionBarrier }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(SqlInjectionAdditionalFlowStep s).step(nodeFrom, nodeTo)
  }
}

/**
 * Detect taint flow of tainted data that reaches a SQL sink.
 */
module SqlInjectionFlow = TaintTracking::Global<SqlInjectionConfig>;
