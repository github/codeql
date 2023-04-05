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
deprecated class PredicateInjectionConf extends TaintTracking::Configuration {
  PredicateInjectionConf() { this = "PredicateInjectionConf" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof PredicateInjectionSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof PredicateInjectionSanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node n1, DataFlow::Node n2) {
    any(PredicateInjectionAdditionalTaintStep s).step(n1, n2)
  }
}

/**
 * A taint-tracking configuration for predicate injection vulnerabilities.
 */
module PredicateInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof PredicateInjectionSink }

  predicate isBarrier(DataFlow::Node sanitizer) { sanitizer instanceof PredicateInjectionSanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    any(PredicateInjectionAdditionalTaintStep s).step(n1, n2)
  }
}

/**
 * Detect taint flow of predicate injection vulnerabilities.
 */
module PredicateInjectionFlow = TaintTracking::Global<PredicateInjectionConfig>;
