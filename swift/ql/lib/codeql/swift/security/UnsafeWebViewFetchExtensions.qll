/**
 * Provides classes and predicates for reasoning about unsafe
 * webview fetch vulnerabilities.
 */

import swift
import codeql.swift.dataflow.DataFlow

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
