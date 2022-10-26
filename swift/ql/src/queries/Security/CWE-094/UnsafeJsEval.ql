/**
 * @name JavaScript Injection
 * @description Evaluating JavaScript code containing a substring from a remote source may lead to remote code execution.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 6.1
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
 * TODO: Extend to more (non-remote) sources in the future.
 */
class Source = RemoteFlowSource;

/**
 * A sink that evaluates a string of JavaScript code.
 */
abstract class Sink extends DataFlow::Node { }

class WKWebView extends Sink {
  WKWebView() {
    any(CallExpr ce |
      ce.getStaticTarget() =
        getMethodWithQualifiedName("WKWebView",
          [
            "evaluateJavaScript(_:completionHandler:)",
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
      ce.getStaticTarget() =
        getMethodWithQualifiedName("WKUserContentController", "addUserScript(_:)")
    ).getArgument(0).getExpr() = this.asExpr()
  }
}

class UIWebView extends Sink {
  UIWebView() {
    any(CallExpr ce |
      ce.getStaticTarget() =
        getMethodWithQualifiedName(["UIWebView", "WebView"], "stringByEvaluatingJavaScript(from:)")
    ).getArgument(0).getExpr() = this.asExpr()
  }
}

class JSContext extends Sink {
  JSContext() {
    any(CallExpr ce |
      ce.getStaticTarget() =
        getMethodWithQualifiedName("JSContext",
          ["evaluateScript(_:)", "evaluateScript(_:withSourceURL:)"])
    ).getArgument(0).getExpr() = this.asExpr()
  }
}

class JSEvaluateScript extends Sink {
  JSEvaluateScript() {
    any(CallExpr ce |
      ce.getStaticTarget() = getFunctionWithQualifiedName("JSEvaluateScript(_:_:_:_:_:_:)")
    ).getArgument(1).getExpr() = this.asExpr()
  }
}

// TODO: Consider moving the following to the library, e.g.
// - Decl.hasQualifiedName(moduleName?, declaringDeclName?, declName)
// - parentDecl = memberDecl.getDeclaringDecl() <=> parentDecl.getAMember() = memberDecl
IterableDeclContext getDeclaringDeclOf(Decl member) { result.getAMember() = member }

MethodDecl getMethodWithQualifiedName(string className, string methodName) {
  result.getName() = methodName and
  getDeclaringDeclOf(result).(NominalTypeDecl).getName() = className
}

AbstractFunctionDecl getFunctionWithQualifiedName(string funcName) {
  result.getName() = funcName and
  not result.hasSelfParam()
}

/**
 * A taint configuration from taint sources to sinks for this query.
 */
class UnsafeJsEvalConfig extends TaintTracking::Configuration {
  UnsafeJsEvalConfig() { this = "UnsafeJsEvalConfig" }

  override predicate isSource(DataFlow::Node node) { node instanceof Source }

  override predicate isSink(DataFlow::Node node) { node instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    none() // TODO: A conversion to a primitive type or an enum
  }
}

from
  UnsafeJsEvalConfig config, DataFlow::PathNode sourceNode, DataFlow::PathNode sinkNode, Sink sink
where
  config.hasFlowPath(sourceNode, sinkNode) and
  sink = sinkNode.getNode()
select sink, sourceNode, sinkNode, "Evaluation of uncontrolled JavaScript from a remote source."
