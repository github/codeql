/**
 * @name JavaScript Injection
 * @description Evaluating JavaScript code containing a substring from a remote source may lead to remote code execution.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 9.3
 * @precision medium
 * @id swift/unsafe-js-eval
 * @tags security
 *       external/cwe/cwe-094
 *       external/cwe/cwe-095
 *       external/cwe/cwe-749
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.dataflow.FlowSources
private import codeql.swift.dataflow.ExternalFlow

/*
 * Copied unchanged from
 * swift/ql/lib/codeql/swift/security/UnsafeJsEvalQuery.qll.
 */

/**
 * A taint configuration from taint sources to sinks for this query.
 */
module UnsafeJsEvalConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof FlowSource }

  predicate isSink(DataFlow::Node node) { node instanceof UnsafeJsEvalSink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof UnsafeJsEvalBarrier }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(UnsafeJsEvalAdditionalFlowStep s).step(nodeFrom, nodeTo)
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Detect taint flow of taint sources to sinks for this query.
 */
module UnsafeJsEvalFlow = TaintTracking::Global<UnsafeJsEvalConfig>;

/*
 * Copied unchanged from
 * swift/ql/lib/codeql/swift/security/UnsafeJsEvalExtensions.qll.
 */

/**
 * A dataflow sink for javascript evaluation vulnerabilities.
 */
abstract class UnsafeJsEvalSink extends DataFlow::Node { }

/**
 * A barrier for javascript evaluation vulnerabilities.
 */
abstract class UnsafeJsEvalBarrier extends DataFlow::Node { }

/**
 * A unit class for adding additional flow steps.
 */
class UnsafeJsEvalAdditionalFlowStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a flow
   * step for paths related to javascript evaluation vulnerabilities.
   */
  abstract predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo);
}

/**
 * A default javascript evaluation sink for the `WKWebView` interface.
 */
private class WKWebViewDefaultUnsafeJsEvalSink extends UnsafeJsEvalSink {
  WKWebViewDefaultUnsafeJsEvalSink() {
    any(CallExpr ce |
      ce.getStaticTarget()
          .(Method)
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
 * A default javascript evaluation sink for the `WKUserContentController` interface.
 */
private class WKUserContentControllerDefaultUnsafeJsEvalSink extends UnsafeJsEvalSink {
  WKUserContentControllerDefaultUnsafeJsEvalSink() {
    any(CallExpr ce |
      ce.getStaticTarget().(Method).hasQualifiedName("WKUserContentController", "addUserScript(_:)")
    ).getArgument(0).getExpr() = this.asExpr()
  }
}

/**
 * A default javascript evaluation sink for the `UIWebView` and `WebView` interfaces.
 */
private class UIWebViewDefaultUnsafeJsEvalSink extends UnsafeJsEvalSink {
  UIWebViewDefaultUnsafeJsEvalSink() {
    any(CallExpr ce |
      ce.getStaticTarget()
          .(Method)
          .hasQualifiedName(["UIWebView", "WebView"], "stringByEvaluatingJavaScript(from:)")
    ).getArgument(0).getExpr() = this.asExpr()
  }
}

/**
 * A default javascript evaluation sink for the `JSContext` interface.
 */
private class JSContextDefaultUnsafeJsEvalSink extends UnsafeJsEvalSink {
  JSContextDefaultUnsafeJsEvalSink() {
    any(CallExpr ce |
      ce.getStaticTarget()
          .(Method)
          .hasQualifiedName("JSContext", ["evaluateScript(_:)", "evaluateScript(_:withSourceURL:)"])
    ).getArgument(0).getExpr() = this.asExpr()
  }
}

/**
 * A default javascript evaluation sink for the `JSEvaluateScript` function.
 */
private class JSEvaluateScriptDefaultUnsafeJsEvalSink extends UnsafeJsEvalSink {
  JSEvaluateScriptDefaultUnsafeJsEvalSink() {
    any(CallExpr ce | ce.getStaticTarget().(FreeFunction).hasName("JSEvaluateScript(_:_:_:_:_:_:)"))
        .getArgument(1)
        .getExpr() = this.asExpr()
  }
}

/**
 * A default javascript evaluation additional taint step.
 */
private class DefaultUnsafeJsEvalAdditionalFlowStep extends UnsafeJsEvalAdditionalFlowStep {
  override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    exists(MemberRefExpr e, Expr self, VarDecl member |
      self.getType().getFullName().matches(["Unsafe%Buffer%", "Unsafe%Pointer%"]) and
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
  DefaultUnsafeJsEvalSink() { sinkNode(this, "code-injection") }
}

/**
 * A barrier for javascript evaluation.
 */
private class UnsafeJsEvalDefaultBarrier extends UnsafeJsEvalBarrier {
  UnsafeJsEvalDefaultBarrier() {
    // any numeric type
    this.asExpr().getType().getUnderlyingType().getABaseType*().getName() =
      ["Numeric", "SignedInteger", "UnsignedInteger"]
  }
}

import UnsafeJsEvalFlow::PathGraph

from
  UnsafeJsEvalFlow::PathNode sourceNode, UnsafeJsEvalFlow::PathNode sinkNode, UnsafeJsEvalSink sink
where
  UnsafeJsEvalFlow::flowPath(sourceNode, sinkNode) and
  sink = sinkNode.getNode()
select sink, sourceNode, sinkNode, "Evaluation of uncontrolled JavaScript from a remote source."
