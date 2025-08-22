/**
 * Provides classes and predicates for reasoning about unsafe
 * webview fetch vulnerabilities.
 */

import swift
import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.ExternalFlow

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
