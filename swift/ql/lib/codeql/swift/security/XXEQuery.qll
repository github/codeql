/**
 * Provides a taint-tracking configuration for reasoning about XML external entities
 * (XXE) vulnerabilities.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.FlowSources
import codeql.swift.dataflow.TaintTracking
import codeql.swift.security.XXEExtensions

/**
 * A taint-tracking configuration for XML external entities (XXE) vulnerabilities.
 */
class XxeConfiguration extends TaintTracking::Configuration {
  XxeConfiguration() { this = "XxeConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof XxeSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) { sanitizer instanceof XxeSanitizer }

  override predicate isAdditionalTaintStep(DataFlow::Node n1, DataFlow::Node n2) {
    any(XxeAdditionalTaintStep s).step(n1, n2)
  }
}
