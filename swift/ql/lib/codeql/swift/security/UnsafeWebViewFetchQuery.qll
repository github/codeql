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
module UnsafeWebViewFetchConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node node) {
    exists(UnsafeWebViewFetchSink sink |
      node = sink or
      node.asExpr() = sink.getBaseUrl()
    )
  }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof UnsafeWebViewFetchBarrier }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(UnsafeWebViewFetchAdditionalFlowStep s).step(nodeFrom, nodeTo)
  }
}

/**
 * Detect taint flow of taint sources to sinks (and `baseURL` arguments) for this query.
 */
module UnsafeWebViewFetchFlow = TaintTracking::Global<UnsafeWebViewFetchConfig>;
