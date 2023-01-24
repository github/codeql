/**
 * Provides classes and predicates for reasoning about javascript
 * evaluation vulnerabilities.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.FlowSources

/**
 * A source of untrusted, user-controlled data.
 */
class Source = FlowSource;

/**
 * A sink that evaluates a string of JavaScript code.
 */
abstract class Sink extends DataFlow::Node { }

class WKWebView extends Sink {
  WKWebView() {
    any(CallExpr ce |
      ce.getStaticTarget()
          .(MethodDecl)
          .hasQualifiedName("WKWebView",
            [
              "evaluateJavaScript(_:)", "evaluateJavaScript(_:completionHandler:)",
              "evaluateJavaScript(_:in:in:completionHandler:)",
              "evaluateJavaScript(_:in:contentWorld:)",
              "callAsyncJavaScript(_:arguments:in:in:completionHandler:)",
              "callAsyncJavaScript(_:arguments:in:contentWorld:)"
            ])
    ).getArgument(0).getExpr() = this.asExpr()
  }
}

class WKUserContentController extends Sink {
  WKUserContentController() {
    any(CallExpr ce |
      ce.getStaticTarget()
          .(MethodDecl)
          .hasQualifiedName("WKUserContentController", "addUserScript(_:)")
    ).getArgument(0).getExpr() = this.asExpr()
  }
}

class UIWebView extends Sink {
  UIWebView() {
    any(CallExpr ce |
      ce.getStaticTarget()
          .(MethodDecl)
          .hasQualifiedName(["UIWebView", "WebView"], "stringByEvaluatingJavaScript(from:)")
    ).getArgument(0).getExpr() = this.asExpr()
  }
}

class JSContext extends Sink {
  JSContext() {
    any(CallExpr ce |
      ce.getStaticTarget()
          .(MethodDecl)
          .hasQualifiedName("JSContext", ["evaluateScript(_:)", "evaluateScript(_:withSourceURL:)"])
    ).getArgument(0).getExpr() = this.asExpr()
  }
}

class JSEvaluateScript extends Sink {
  JSEvaluateScript() {
    any(CallExpr ce |
      ce.getStaticTarget().(FreeFunctionDecl).hasName("JSEvaluateScript(_:_:_:_:_:_:)")
    ).getArgument(1).getExpr() = this.asExpr()
  }
}
