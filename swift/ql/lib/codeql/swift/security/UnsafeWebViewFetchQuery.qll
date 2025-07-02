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

  predicate observeDiffInformedIncrementalMode() {
    any() // TODO: Make sure that the location overrides match the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 36 (/Users/d10c/src/semmle-code/ql/swift/ql/src/queries/Security/CWE-079/UnsafeWebViewFetch.ql@39:8:39:11)
  }

  Location getASelectedSourceLocation(DataFlow::Node source) {
    none() // TODO: Make sure that this source location matches the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 36 (/Users/d10c/src/semmle-code/ql/swift/ql/src/queries/Security/CWE-079/UnsafeWebViewFetch.ql@39:8:39:11)
  }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    none() // TODO: Make sure that this sink location matches the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 36 (/Users/d10c/src/semmle-code/ql/swift/ql/src/queries/Security/CWE-079/UnsafeWebViewFetch.ql@39:8:39:11)
  }
}

/**
 * Detect taint flow of taint sources to sinks (and `baseURL` arguments) for this query.
 */
module UnsafeWebViewFetchFlow = TaintTracking::Global<UnsafeWebViewFetchConfig>;
