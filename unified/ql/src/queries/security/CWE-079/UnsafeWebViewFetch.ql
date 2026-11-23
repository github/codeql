/**
 * @name Unsafe WebView fetch
 * @description Fetching data in a WebView without restricting the base URL may allow an attacker to access sensitive local data, or enable cross-site scripting attack.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.8
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
private import codeql.swift.dataflow.ExternalFlow

// From swift/ql/lib/codeql/swift/security/UnsafeWebViewFetchQuery.qll:

/**
 * Provides a taint-tracking configuration for reasoning about unsafe
 * webview fetch vulnerabilities.
 */

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
    none() // can't override location accurately because of secondary use in select.
  }
}

/**
 * Detect taint flow of taint sources to sinks (and `baseURL` arguments) for this query.
 */
module UnsafeWebViewFetchFlow = TaintTracking::Global<UnsafeWebViewFetchConfig>;

// From swift/ql/lib/codeql/swift/security/UnsafeWebViewFetchExtensions.qll:

/**
 * Provides classes and predicates for reasoning about unsafe
 * webview fetch vulnerabilities.
 */

/**
 * A dataflow sink for unsafe webview fetch vulnerabilities.
 */
abstract class UnsafeWebViewFetchSink extends DataFlow::Node {
  /**
   * Gets the `baseURL` argument associated with this sink (if any). These arguments affect
   * the way sinks are reported and are also sinks themselves.
   */
  Expr getBaseUrl() { none() }
}

/**
 * A barrier for unsafe webview fetch vulnerabilities.
 */
abstract class UnsafeWebViewFetchBarrier extends DataFlow::Node { }

/**
 * A unit class for adding additional flow steps.
 */
class UnsafeWebViewFetchAdditionalFlowStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a flow
   * step for paths related to unsafe webview fetch vulnerabilities.
   */
  abstract predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo);
}

/**
 * A default uncontrolled format string sink, such as certain arguments
 * to `UIWebView.loadHTMLString`.
 */
private class UIKitWebKitWebViewFetchSink extends UnsafeWebViewFetchSink {
  Expr baseUrl;

  UIKitWebKitWebViewFetchSink() {
    exists(Method funcDecl, CallExpr call, string className, string funcName, int arg, int baseArg |
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
      // match up `className`, `funcName`.
      funcDecl.hasQualifiedName(className, funcName) and
      // match up `this`, `baseURL`
      this.asExpr() = call.getArgument(arg).getExpr() and // URL
      baseUrl = call.getArgument(baseArg).getExpr() // baseURL
    )
  }

  override Expr getBaseUrl() { result = baseUrl }
}

/**
 * A sink defined in a CSV model.
 *
 * Note that sinks defined in this way never have a recognized `baseURL`
 * argument, which may limit the accuracy of results.
 */
private class DefaultUnsafeWebViewFetchSink extends UnsafeWebViewFetchSink {
  DefaultUnsafeWebViewFetchSink() { sinkNode(this, "webview-fetch") }
}

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
