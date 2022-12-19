/**
 * @name JavaScript Injection
 * @description Evaluating JavaScript code containing a substring from a remote source may lead to remote code execution.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 9.3
 * @precision high
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
import DataFlow::PathGraph

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

/**
 * A taint configuration from taint sources to sinks for this query.
 */
class UnsafeJsEvalConfig extends TaintTracking::Configuration {
  UnsafeJsEvalConfig() { this = "UnsafeJsEvalConfig" }

  override predicate isSource(DataFlow::Node node) { node instanceof Source }

  override predicate isSink(DataFlow::Node node) { node instanceof Sink }

  // TODO: convert to new taint flow models
  override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    exists(Argument arg |
      arg =
        any(CallExpr ce |
          ce.getStaticTarget().(MethodDecl).hasQualifiedName("String", "init(decoding:as:)")
        ).getArgument(0)
      or
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

from
  UnsafeJsEvalConfig config, DataFlow::PathNode sourceNode, DataFlow::PathNode sinkNode, Sink sink
where
  config.hasFlowPath(sourceNode, sinkNode) and
  sink = sinkNode.getNode()
select sink, sourceNode, sinkNode, "Evaluation of uncontrolled JavaScript from a remote source."
