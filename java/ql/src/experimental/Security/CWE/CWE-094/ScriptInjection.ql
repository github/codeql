/**
 * @name Injection in JavaScript Engine
 * @description Evaluation of a user-controlled malicious JavaScript or Java expression in
 *              JavaScript Engine may lead to remote code execution.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/unsafe-eval
 * @tags security
 *       external/cwe/cwe-094
 */

import java
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

class ScriptEngineMethod extends Method {
  ScriptEngineMethod() {
    this.getDeclaringType().getASupertype*().hasQualifiedName("javax.script", "ScriptEngine") and
    this.hasName("eval")
  }
}

/** The context class `org.mozilla.javascript.Context` of Rhino JavaScript Engine. */
class RhinoContext extends RefType {
  RhinoContext() { this.hasQualifiedName("org.mozilla.javascript", "Context") }
}

/**
 * A method that evaluates a Rhino expression.
 */
class RhinoEvaluateExpressionMethod extends Method {
  RhinoEvaluateExpressionMethod() {
    this.getDeclaringType().getAnAncestor*() instanceof RhinoContext and
    (
      hasName("evaluateString") or
      hasName("evaluateReader")
    )
  }
}

predicate scriptEngine(MethodAccess ma, Expr sink) {
  exists(Method m | m = ma.getMethod() |
    m instanceof ScriptEngineMethod and
    sink = ma.getArgument(0)
  )
}

/**
 * Holds if `ma` has Rhino code injection vulnerabilities.
 */
predicate evaluateRhinoExpression(MethodAccess ma, Expr sink) {
  exists(RhinoEvaluateExpressionMethod m | m = ma.getMethod() |
    sink = ma.getArgument(1) and // The second argument is the JavaScript or Java input
    not exists(MethodAccess ca |
      (
        ca.getMethod().hasName("initSafeStandardObjects") // safe mode
        or
        ca.getMethod().hasName("setClassShutter") // `ClassShutter` constraint is enforced
      ) and
      ma.getQualifier() = ca.getQualifier().(VarAccess).getVariable().getAnAccess()
    )
  )
}

class ScriptInjectionSink extends DataFlow::ExprNode {
  ScriptInjectionSink() {
    scriptEngine(_, this.getExpr()) or
    evaluateRhinoExpression(_, this.getExpr())
  }

  MethodAccess getMethodAccess() {
    scriptEngine(result, this.getExpr()) or
    evaluateRhinoExpression(result, this.getExpr())
  }
}

class ScriptInjectionConfiguration extends TaintTracking::Configuration {
  ScriptInjectionConfiguration() { this = "ScriptInjectionConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource
    or
    source instanceof LocalUserInput
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof ScriptInjectionSink }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, ScriptInjectionConfiguration conf
where conf.hasFlowPath(source, sink)
select sink.getNode().(ScriptInjectionSink).getMethodAccess(), source, sink,
  "JavaScript Engine evaluate $@.", source.getNode(), "user input"
