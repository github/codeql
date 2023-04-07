/**
 * Provides a taint-tracking configuration for reasoning about unsafe
 * webview fetch vulnerabilities.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.dataflow.FlowSources
import codeql.swift.security.UnsafeWebViewFetchExtensions

/**
 * A taint configuration from taint sources to sinks (and `baseURL` arguments)
 * for this query.
 */
deprecated class UnsafeWebViewFetchConfig extends TaintTracking::Configuration {
  UnsafeWebViewFetchConfig() { this = "UnsafeWebViewFetchConfig" }

  override predicate isSource(DataFlow::Node node) { node instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node node) {
    exists(UnsafeWebViewFetchSink sink |
      node = sink or
      node.asExpr() = sink.getBaseUrl()
    )
  }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof UnsafeWebViewFetchSanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(UnsafeWebViewFetchAdditionalTaintStep s).step(nodeFrom, nodeTo)
  }
}

/**
 * A taint configuration from taint sources to sinks (and `baseURL` arguments)
 * for this query.
 */
module UnsafeWebViewFetchConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node node) {
    exists(UnsafeWebViewFetchSink sink |
      node = sink or
      node.asExpr() = sink.getBaseUrl()
    )
  }

  predicate isBarrier(DataFlow::Node sanitizer) { sanitizer instanceof UnsafeWebViewFetchSanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(UnsafeWebViewFetchAdditionalTaintStep s).step(nodeFrom, nodeTo)
  }
}

/**
 * Detect taint flow of taint sources to sinks (and `baseURL` arguments) for this query.
 */
module UnsafeWebViewFetchFlow = TaintTracking::Global<UnsafeWebViewFetchConfig>;
