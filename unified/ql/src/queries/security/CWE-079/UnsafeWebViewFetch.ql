/**
 * @name Unsafe WebView fetch
 * @description Fetching data in a WebView without restricting the base URL may allow an attacker to access sensitive local data, or enable cross-site scripting attack.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.8
 * @precision high
 * @id unified/swift/unsafe-webview-fetch
 * @tags security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-095
 *       external/cwe/cwe-749
 */

import unified

/**
 * A modeled WebView fetch, with its associated base URL if present.
 */
private class UnsafeWebViewFetchSink extends DataFlow::Node {
  UnsafeWebViewFetchSink() { Models::isSink(this, "webview-fetch") }

  /**
   * Gets a base URL argument of this WebView fetch.
   */
  DataFlow::Node getABaseUrl() {
    // `result` is a `webview-baseurl` sink that's part of the same
    // call as this `webview-fetch` sink.
    exists(CallExpr call |
      Models::isSink(result, "webview-baseurl") and
      call.getAnArgument().getValue() = this.asExpr() and
      call.getAnArgument().getValue() = result.asExpr()
    )
  }
}

/**
 * A taint configuration from taint sources to sinks for this query, and to `baseURL` arguments.
 */
module UnsafeWebViewFetchConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { Models::isSource(node, _) }

  predicate isSink(DataFlow::Node node) {
    exists(UnsafeWebViewFetchSink sink |
      node = sink or
      node = sink.getABaseUrl()
    )
  }

  predicate observeDiffInformedIncrementalMode() {
    none() // can't override location accurately because of secondary use in select.
    // TODO: review this, perhaps split into two flows and use two sink models even???
  }
}

// TODO: Recover the relative-URL and Data paths marked MISSING in the tests.
module UnsafeWebViewFetchFlow = TaintTracking::Global<UnsafeWebViewFetchConfig>;

import UnsafeWebViewFetchFlow::PathGraph

from
  UnsafeWebViewFetchFlow::PathNode sourceNode, UnsafeWebViewFetchFlow::PathNode sinkNode,
  UnsafeWebViewFetchSink sink, string message
where
  UnsafeWebViewFetchFlow::flowPath(sourceNode, sinkNode) and
  sink = sinkNode.getNode() and
  (
    // no base URL
    not exists(sink.getABaseUrl()) and
    message = "Tainted data is used in a WebView fetch."
    or
    // base URL is nil
    sink.getABaseUrl().asExpr().(BuiltinExpr).getValue() = "nil" and
    message = "Tainted data is used in a WebView fetch without restricting the base URL."
    or
    // base URL is also tainted
    exists(DataFlow::Node baseUrl |
      baseUrl = sink.getABaseUrl() and
      UnsafeWebViewFetchFlow::flowTo(baseUrl)
    ) and
    message = "Tainted data is used in a WebView fetch with a tainted base URL."
  )
select sink, sourceNode, sinkNode, message
