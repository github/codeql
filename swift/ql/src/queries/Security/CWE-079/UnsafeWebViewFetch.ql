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
import codeql.swift.dataflow.TaintTracking
import codeql.swift.dataflow.FlowSources
import DataFlow::PathGraph

/**
 * A sink that is a candidate result for this query, such as certain arguments
 * to `UIWebView.loadHTMLString`.
 */
class Sink extends DataFlow::Node {
  Expr baseUrl;

  Sink() {
    exists(
      MethodDecl funcDecl, CallExpr call, string className, string funcName, int arg, int baseArg
    |
      // arguments to method calls...
      (
        // `loadHTMLString`
        className = ["UIWebView", "WKWebView"] and
        funcName = "loadHTMLString(_:baseURL:)" and
        arg = 0 and
        baseArg = 1
        or
        // `UIWebView.load`
        className = "UIWebView" and
        funcName = "load(_:mimeType:textEncodingName:baseURL:)" and
        arg = 0 and
        baseArg = 3
        or
        // `WKWebView.load`
        className = "WKWebView" and
        funcName = "load(_:mimeType:characterEncodingName:baseURL:)" and
        arg = 0 and
        baseArg = 3
      ) and
      call.getStaticTarget() = funcDecl and
      // match up `funcName`, `paramName`, `arg`, `node`.
      funcDecl.hasQualifiedName(className, funcName) and
      call.getArgument(arg).getExpr() = this.asExpr() and
      // match up `baseURLArg`
      call.getArgument(baseArg).getExpr() = baseUrl
    )
  }

  /**
   * Gets the `baseURL` argument associated with this sink.
   */
  Expr getBaseUrl() { result = baseUrl }
}

/**
 * A taint configuration from taint sources to sinks (and `baseURL` arguments)
 * for this query.
 */
class UnsafeWebViewFetchConfig extends TaintTracking::Configuration {
  UnsafeWebViewFetchConfig() { this = "UnsafeWebViewFetchConfig" }

  override predicate isSource(DataFlow::Node node) { node instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node node) {
    node instanceof Sink or
    node.asExpr() = any(Sink s).getBaseUrl()
  }
}

from
  UnsafeWebViewFetchConfig config, DataFlow::PathNode sourceNode, DataFlow::PathNode sinkNode,
  Sink sink, string message
where
  config.hasFlowPath(sourceNode, sinkNode) and
  sink = sinkNode.getNode() and
  (
    // base URL is nil
    sink.getBaseUrl() instanceof NilLiteralExpr and
    message = "Tainted data is used in a WebView fetch without restricting the base URL."
    or
    // base URL is tainted
    config.hasFlowToExpr(sink.getBaseUrl()) and
    message = "Tainted data is used in a WebView fetch with a tainted base URL."
  )
select sink, sourceNode, sinkNode, message
