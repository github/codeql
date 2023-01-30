/**
 * Provides a taint-tracking configuration for reasoning about cleartext logging of
 * sensitive data vulnerabilities.
 */

import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.TaintTracking
private import codeql.swift.security.CleartextLoggingExtensions
private import codeql.swift.security.SensitiveExprs

/**
 * A taint-tracking configuration for cleartext logging of sensitive data vulnerabilities.
 */
class CleartextLoggingConfiguration extends TaintTracking::Configuration {
  CleartextLoggingConfiguration() { this = "CleartextLoggingConfiguration" }

  override predicate isSource(DataFlow::Node source) { source.asExpr() instanceof SensitiveExpr }

  override predicate isSink(DataFlow::Node sink) { sink instanceof CleartextLoggingSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof CleartextLoggingSanitizer
  }

  // Disregard paths that contain other paths. This helps with performance.
  override predicate isSanitizerIn(DataFlow::Node node) { this.isSource(node) }

  override predicate isAdditionalTaintStep(DataFlow::Node n1, DataFlow::Node n2) {
    any(CleartextLoggingAdditionalTaintStep s).step(n1, n2)
  }
}
