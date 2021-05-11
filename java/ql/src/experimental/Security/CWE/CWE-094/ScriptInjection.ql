/**
 * @name Injection in Java Script Engine
 * @description Evaluation of user-controlled data using the Java Script Engine may
 *              lead to remote code execution.
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

/** A method of ScriptEngine that allows code injection. */
class ScriptEngineMethod extends Method {
  ScriptEngineMethod() {
    this.getDeclaringType().getASupertype*().hasQualifiedName("javax.script", "ScriptEngine") and
    this.hasName("eval")
    or
    this.getDeclaringType().getASupertype*().hasQualifiedName("javax.script", "Compilable") and
    this.hasName("compile")
    or
    this.getDeclaringType().getASupertype*().hasQualifiedName("javax.script", "ScriptEngineFactory") and
    this.hasName(["getProgram", "getMethodCallSyntax"])
  }
}

/** The context class `org.mozilla.javascript.Context` of Rhino Java Script Engine. */
class RhinoContext extends RefType {
  RhinoContext() { this.hasQualifiedName("org.mozilla.javascript", "Context") }
}

/** A method that evaluates a Rhino expression with `org.mozilla.javascript.Context`. */
class RhinoEvaluateExpressionMethod extends Method {
  RhinoEvaluateExpressionMethod() {
    this.getDeclaringType().getAnAncestor*() instanceof RhinoContext and
    this.hasName([
        "evaluateString", "evaluateReader", "compileFunction", "compileReader", "compileString"
      ])
  }
}

/**
 * A method that compiles a Rhino expression with
 * `org.mozilla.javascript.optimizer.ClassCompiler`.
 */
class RhinoCompileClassMethod extends Method {
  RhinoCompileClassMethod() {
    this.getDeclaringType()
        .getASupertype*()
        .hasQualifiedName("org.mozilla.javascript.optimizer", "ClassCompiler") and
    this.hasName("compileToClassFiles")
  }
}

/**
 * A method that defines a Java class from a Rhino expression with
 * `org.mozilla.javascript.GeneratedClassLoader`.
 */
class RhinoDefineClassMethod extends Method {
  RhinoDefineClassMethod() {
    this.getDeclaringType()
        .getASupertype*()
        .hasQualifiedName("org.mozilla.javascript", "GeneratedClassLoader") and
    this.hasName("defineClass")
  }
}

/** Holds if `ma` is a method access of `ScriptEngineMethod`. */
predicate scriptEngine(MethodAccess ma, Expr sink) {
  exists(Method m | m = ma.getMethod() |
    m instanceof ScriptEngineMethod and
    sink = ma.getArgument(0)
  )
}

/**
 * Holds if a Rhino expression evaluation method is vulnerable to code injection.
 */
predicate evaluateRhinoExpression(MethodAccess ma, Expr sink) {
  exists(RhinoEvaluateExpressionMethod m | m = ma.getMethod() |
    (
      if ma.getMethod().getName() = "compileReader"
      then sink = ma.getArgument(0) // The first argument is the input reader
      else sink = ma.getArgument(1) // The second argument is the JavaScript or Java input
    ) and
    not exists(MethodAccess ca |
      ca.getMethod().hasName(["initSafeStandardObjects", "setClassShutter"]) and // safe mode or `ClassShutter` constraint is enforced
      ma.getQualifier() = ca.getQualifier().(VarAccess).getVariable().getAnAccess()
    )
  )
}

/**
 * Holds if a Rhino expression compilation method is vulnerable to code injection.
 */
predicate compileScript(MethodAccess ma, Expr sink) {
  exists(RhinoCompileClassMethod m | m = ma.getMethod() | sink = ma.getArgument(0))
}

/**
 * Holds if a Rhino class loading method is vulnerable to code injection.
 */
predicate defineClass(MethodAccess ma, Expr sink) {
  exists(RhinoDefineClassMethod m | m = ma.getMethod() | sink = ma.getArgument(1))
}

/** A script injection sink. */
class ScriptInjectionSink extends DataFlow::ExprNode {
  ScriptInjectionSink() {
    scriptEngine(_, this.getExpr()) or
    evaluateRhinoExpression(_, this.getExpr()) or
    compileScript(_, this.getExpr()) or
    defineClass(_, this.getExpr())
  }

  /** An access to the method associated with this sink. */
  MethodAccess getMethodAccess() {
    scriptEngine(result, this.getExpr()) or
    evaluateRhinoExpression(result, this.getExpr()) or
    compileScript(result, this.getExpr()) or
    defineClass(result, this.getExpr())
  }
}

class ScriptInjectionConfiguration extends TaintTracking::Configuration {
  ScriptInjectionConfiguration() { this = "ScriptInjectionConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof ScriptInjectionSink }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, ScriptInjectionConfiguration conf
where conf.hasFlowPath(source, sink)
select sink.getNode().(ScriptInjectionSink).getMethodAccess(), source, sink,
  "Java Script Engine evaluate $@.", source.getNode(), "user input"
