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
import codeql.swift.frameworks.StandardLibrary.String

/**
 * A taint source that is `String(contentsOf:)`.
 * TODO: this shouldn't be needed when `StringSource` in `String.qll` is working.
 */
class StringContentsOfURLSource extends RemoteFlowSource {
  StringContentsOfURLSource() {
    exists(CallExpr call, AbstractFunctionDecl f |
      call.getFunction().(ApplyExpr).getStaticTarget() = f and
      f.getName() = "init(contentsOf:)" and
      f.getParam(0).getType().getName() = "URL" and
      this.asExpr() = call
    )
  }

  override string getSourceType() { result = "" }
}

/**
 * A sink that is a candidate result for this query, such as certain arguments
 * to `UIWebView.loadHTMLString`.
 */
class Sink extends DataFlow::Node {
  Expr baseURL;

  Sink() {
    exists(
      AbstractFunctionDecl funcDecl, CallExpr call, string funcName, string paramName, int arg,
      int baseURLarg
    |
      // arguments to method calls...
      exists(string className, ClassDecl c |
        (
          // `loadHTMLString`
          className = ["UIWebView", "WKWebView"] and
          funcName = "loadHTMLString(_:baseURL:)" and
          paramName = "string"
          or
          // `UIWebView.load`
          className = "UIWebView" and
          funcName = "load(_:mimeType:textEncodingName:baseURL:)" and
          paramName = "data"
          or
          // `WKWebView.load`
          className = "WKWebView" and
          funcName = "load(_:mimeType:characterEncodingName:baseURL:)" and
          paramName = "data"
        ) and
        c.getName() = className and
        c.getAMember() = funcDecl and
        call.getFunction().(ApplyExpr).getStaticTarget() = funcDecl
      ) and
      // match up `funcName`, `paramName`, `arg`, `node`.
      funcDecl.getName() = funcName and
      funcDecl.getParam(pragma[only_bind_into](arg)).getName() = paramName and
      call.getArgument(pragma[only_bind_into](arg)).getExpr() = this.asExpr() and
      // match up `baseURLArg`
      funcDecl.getParam(pragma[only_bind_into](baseURLarg)).getName() = "baseURL" and
      call.getArgument(pragma[only_bind_into](baseURLarg)).getExpr() = baseURL
    )
  }

  /**
   * Gets the `baseURL` argument associated with this sink.
   */
  Expr getBaseURL() { result = baseURL }
}

/**
 * Taint configuration from taint sources to sinks (and `baseURL` arguments)
 * for this query.
 */
class UnsafeWebViewFetchConfig extends TaintTracking::Configuration {
  UnsafeWebViewFetchConfig() { this = "UnsafeWebViewFetchConfig" }

  override predicate isSource(DataFlow::Node node) { node instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node node) {
    node instanceof Sink or
    node.asExpr() = any(Sink s).getBaseURL()
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    // allow flow through `try!` and similar constructs
    // TODO: this should probably be part of DataFlow / TaintTracking.
    node1.asExpr() = node2.asExpr().(AnyTryExpr).getSubExpr()
    or
    // allow flow through `!`
    // TODO: this should probably be part of DataFlow / TaintTracking.
    node1.asExpr() = node2.asExpr().(ForceValueExpr).getSubExpr()
    or
    // allow flow through string concatenation.
    // TODO: this should probably be part of TaintTracking.
    node2.asExpr().(AddExpr).getAnOperand() = node1.asExpr()
    or
    // allow flow through `URL.init`.
    exists(CallExpr call, ClassDecl c, AbstractFunctionDecl f |
      c.getName() = "URL" and
      c.getAMember() = f and
      f.getName() = ["init(string:)", "init(string:relativeTo:)"] and
      call.getFunction().(ApplyExpr).getStaticTarget() = f and
      node1.asExpr() = call.getArgument(_).getExpr() and
      node2.asExpr() = call
    )
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
    sink.getBaseURL() instanceof NilLiteralExpr and
    message = "Tainted data is used in a WebView fetch without restricting the base URL."
    or
    // base URL is tainted
    config.hasFlow(_, any(DataFlow::Node n | n.asExpr() = sink.getBaseURL())) and
    message = "Tainted data is used in a WebView fetch with a tainted base URL."
  )
select sinkNode, sourceNode, sinkNode, message
