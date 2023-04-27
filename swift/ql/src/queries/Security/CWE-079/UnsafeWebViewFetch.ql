/**
 * @name Unsafe WebView fetch
 * @description Fetching data in a WebView without restricting the base URL may allow an attacker to access sensitive local data, or enable cross-site scripting attack.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 6.1
 * @precision high
 * @id swift/unsafe-webview-fetch
 * @tags security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-095
 *       external/cwe/cwe-749
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.security.UnsafeWebViewFetchQuery
import UnsafeWebViewFetchFlow::PathGraph

from
  UnsafeWebViewFetchFlow::PathNode sourceNode, UnsafeWebViewFetchFlow::PathNode sinkNode,
  UnsafeWebViewFetchSink sink, string message
where
  UnsafeWebViewFetchFlow::flowPath(sourceNode, sinkNode) and
  sink = sinkNode.getNode() and
  (
    // no base URL
    not exists(sink.getBaseUrl()) and
    message = "Tainted data is used in a WebView fetch."
    or
    // base URL is nil
    sink.getBaseUrl() instanceof NilLiteralExpr and
    message = "Tainted data is used in a WebView fetch without restricting the base URL."
    or
    // base URL is also tainted
    UnsafeWebViewFetchFlow::flowToExpr(sink.getBaseUrl()) and
    message = "Tainted data is used in a WebView fetch with a tainted base URL."
  )
select sink, sourceNode, sinkNode, message
