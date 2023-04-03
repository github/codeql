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
deprecated class SqlInjectionConfig extends TaintTracking::Configuration {
  SqlInjectionConfig() { this = "SqlInjectionConfig" }

  override predicate isSource(DataFlow::Node node) { node instanceof FlowSource }

  override predicate isSink(DataFlow::Node node) { node instanceof SqlInjectionSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof SqlInjectionSanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(SqlInjectionAdditionalTaintStep s).step(nodeFrom, nodeTo)
  }
}

/**
 * A taint configuration for tainted data that reaches a SQL sink.
 */
module SqlInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof FlowSource }

  predicate isSink(DataFlow::Node node) { node instanceof SqlInjectionSink }

  predicate isBarrier(DataFlow::Node sanitizer) { sanitizer instanceof SqlInjectionSanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(SqlInjectionAdditionalTaintStep s).step(nodeFrom, nodeTo)
  }
}

/**
 * Detect taint flow of tainted data that reaches a SQL sink.
 */
module SqlInjectionFlow = TaintTracking::Global<SqlInjectionConfig>;
