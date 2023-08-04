/**
 * Provides a taint-tracking configuration for reasoning about predicate injection
 * vulnerabilities.
 */

import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.FlowSources
private import codeql.swift.dataflow.TaintTracking
private import codeql.swift.security.PredicateInjectionExtensions

/**
 * A taint-tracking configuration for predicate injection vulnerabilities.
 */
module PredicateInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof FlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof PredicateInjectionSink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof PredicateInjectionBarrier }

  predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    any(PredicateInjectionAdditionalFlowStep s).step(n1, n2)
  }
}

/**
 * Detect taint flow of predicate injection vulnerabilities.
 */
module PredicateInjectionFlow = TaintTracking::Global<PredicateInjectionConfig>;
