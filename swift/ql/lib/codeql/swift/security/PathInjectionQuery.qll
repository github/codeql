/**
 * Provides a taint-tracking configuration for reasoning about path injection
 * vulnerabilities.
 */

import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.ExternalFlow
private import codeql.swift.dataflow.FlowSources
private import codeql.swift.dataflow.TaintTracking
private import codeql.swift.security.PathInjectionExtensions

/**
 * A taint-tracking configuration for path injection vulnerabilities.
 */
deprecated class PathInjectionConfiguration extends TaintTracking::Configuration {
  PathInjectionConfiguration() { this = "PathInjectionConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof PathInjectionSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof PathInjectionSanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(PathInjectionAdditionalTaintStep s).step(node1, node2)
  }
}

/**
 * A taint-tracking configuration for path injection vulnerabilities.
 */
module PathInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof PathInjectionSink }

  predicate isBarrier(DataFlow::Node sanitizer) { sanitizer instanceof PathInjectionSanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(PathInjectionAdditionalTaintStep s).step(node1, node2)
  }
}

/**
 * Detect taint flow of path injection vulnerabilities.
 */
module PathInjectionFlow = TaintTracking::Global<PathInjectionConfig>;
