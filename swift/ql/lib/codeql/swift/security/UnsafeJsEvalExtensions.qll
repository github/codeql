/**
 * Provides classes and predicates for reasoning about javascript
 * evaluation vulnerabilities.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.FlowSources
private import codeql.swift.dataflow.ExternalFlow

/**
 * A dataflow sink for javascript evaluation vulnerabilities.
 */
abstract class UnsafeJsEvalSink extends DataFlow::Node { }

/**
 * A sanitizer for javascript evaluation vulnerabilities.
 */
abstract class UnsafeJsEvalSanitizer extends DataFlow::Node { }

/**
 * A unit class for adding additional taint steps.
 */
class UnsafeJsEvalAdditionalTaintStep extends Unit {
  abstract predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo);
}

/**
 * A default SQL injection sink for the `WKWebView` interface.
 */
private class WKWebViewDefaultUnsafeJsEvalSink extends UnsafeJsEvalSink {
  WKWebViewDefaultUnsafeJsEvalSink() {
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

/**
 * A default SQL injection sink for the `WKUserContentController` interface.
 */
private class WKUserContentControllerDefaultUnsafeJsEvalSink extends UnsafeJsEvalSink {
  WKUserContentControllerDefaultUnsafeJsEvalSink() {
    any(CallExpr ce |
      ce.getStaticTarget()
          .(MethodDecl)
          .hasQualifiedName("WKUserContentController", "addUserScript(_:)")
    ).getArgument(0).getExpr() = this.asExpr()
  }
}

/**
 * A default SQL injection sink for the `UIWebView` and `WebView` interfaces.
 */
private class UIWebViewDefaultUnsafeJsEvalSink extends UnsafeJsEvalSink {
  UIWebViewDefaultUnsafeJsEvalSink() {
    any(CallExpr ce |
      ce.getStaticTarget()
          .(MethodDecl)
          .hasQualifiedName(["UIWebView", "WebView"], "stringByEvaluatingJavaScript(from:)")
    ).getArgument(0).getExpr() = this.asExpr()
  }
}

/**
 * A default SQL injection sink for the `JSContext` interface.
 */
private class JSContextDefaultUnsafeJsEvalSink extends UnsafeJsEvalSink {
  JSContextDefaultUnsafeJsEvalSink() {
    any(CallExpr ce |
      ce.getStaticTarget()
          .(MethodDecl)
          .hasQualifiedName("JSContext", ["evaluateScript(_:)", "evaluateScript(_:withSourceURL:)"])
    ).getArgument(0).getExpr() = this.asExpr()
  }
}

/**
 * A default SQL injection sink for the `JSEvaluateScript` function.
 */
private class JSEvaluateScriptDefaultUnsafeJsEvalSink extends UnsafeJsEvalSink {
  JSEvaluateScriptDefaultUnsafeJsEvalSink() {
    any(CallExpr ce |
      ce.getStaticTarget().(FreeFunctionDecl).hasName("JSEvaluateScript(_:_:_:_:_:_:)")
    ).getArgument(1).getExpr() = this.asExpr()
  }
}

/**
 * A default SQL injection sanitizer.
 */
private class DefaultUnsafeJsEvalAdditionalTaintStep extends UnsafeJsEvalAdditionalTaintStep {
  override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    exists(Argument arg |
      arg =
        any(CallExpr ce |
          ce.getStaticTarget()
              .(FreeFunctionDecl)
              .hasName([
                  "JSStringCreateWithUTF8CString(_:)", "JSStringCreateWithCharacters(_:_:)",
                  "JSStringRetain(_:)"
                ])
        ).getArgument(0)
    |
      nodeFrom.asExpr() = arg.getExpr() and
      nodeTo.asExpr() = arg.getApplyExpr()
    )
    or
    exists(CallExpr ce, Expr self, AbstractClosureExpr closure |
      ce.getStaticTarget()
          .getName()
          .matches(["withContiguousStorageIfAvailable(%)", "withUnsafeBufferPointer(%)"]) and
      self = ce.getQualifier() and
      ce.getArgument(0).getExpr() = closure
    |
      nodeFrom.asExpr() = self and
      nodeTo.(DataFlow::ParameterNode).getParameter() = closure.getParam(0)
    )
    or
    exists(MemberRefExpr e, Expr self, VarDecl member |
      self.getType().getName().matches(["Unsafe%Buffer%", "Unsafe%Pointer%"]) and
      member.getName() = "baseAddress"
    |
      e.getBase() = self and
      e.getMember() = member and
      nodeFrom.asExpr() = self and
      nodeTo.asExpr() = e
    )
  }
}

/**
 * A sink defined in a CSV model.
 */
private class DefaultUnsafeJsEvalSink extends UnsafeJsEvalSink {
  DefaultUnsafeJsEvalSink() { sinkNode(this, "js-eval") }
}
