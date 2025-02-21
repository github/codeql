/**
 * @name Injection in Java Script Engine
 * @description Evaluation of user-controlled data using the Java Script Engine may
 *              lead to remote code execution.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/unsafe-eval
 * @tags security
 *       experimental
 *       external/cwe/cwe-094
 */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import ScriptInjectionFlow::PathGraph

/** A method of ScriptEngine that allows code injection. */
class ScriptEngineMethod extends Method {
  ScriptEngineMethod() {
    this.getDeclaringType().getAnAncestor().hasQualifiedName("javax.script", "ScriptEngine") and
    this.hasName("eval")
    or
    this.getDeclaringType().getAnAncestor().hasQualifiedName("javax.script", "Compilable") and
    this.hasName("compile")
    or
    this.getDeclaringType().getAnAncestor().hasQualifiedName("javax.script", "ScriptEngineFactory") and
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
        .getAnAncestor()
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
        .getAnAncestor()
        .hasQualifiedName("org.mozilla.javascript", "GeneratedClassLoader") and
    this.hasName("defineClass")
  }
}

/**
 * Holds if `ma` is a call to a `ScriptEngineMethod` and `sink` is an argument that
 * will be executed.
 */
predicate isScriptArgument(MethodCall ma, Expr sink) {
  exists(ScriptEngineMethod m |
    m = ma.getMethod() and
    if m.getDeclaringType().getAnAncestor().hasQualifiedName("javax.script", "ScriptEngineFactory")
    then sink = ma.getArgument(_) // all arguments allow script injection
    else sink = ma.getArgument(0)
  )
}

/**
 * Holds if a Rhino expression evaluation method is vulnerable to code injection.
 */
predicate evaluatesRhinoExpression(MethodCall ma, Expr sink) {
  exists(RhinoEvaluateExpressionMethod m | m = ma.getMethod() |
    (
      if ma.getMethod().getName() = "compileReader"
      then sink = ma.getArgument(0) // The first argument is the input reader
      else sink = ma.getArgument(1) // The second argument is the JavaScript or Java input
    ) and
    not exists(MethodCall ca |
      ca.getMethod().hasName(["initSafeStandardObjects", "setClassShutter"]) and // safe mode or `ClassShutter` constraint is enforced
      ma.getQualifier() = ca.getQualifier().(VarAccess).getVariable().getAnAccess()
    )
  )
}

/**
 * Holds if a Rhino expression compilation method is vulnerable to code injection.
 */
predicate compilesScript(MethodCall ma, Expr sink) {
  exists(RhinoCompileClassMethod m | m = ma.getMethod() | sink = ma.getArgument(0))
}

/**
 * Holds if a Rhino class loading method is vulnerable to code injection.
 */
predicate definesRhinoClass(MethodCall ma, Expr sink) {
  exists(RhinoDefineClassMethod m | m = ma.getMethod() | sink = ma.getArgument(1))
}

/** A script injection sink. */
class ScriptInjectionSink extends DataFlow::ExprNode {
  MethodCall methodAccess;

  ScriptInjectionSink() {
    isScriptArgument(methodAccess, this.getExpr()) or
    evaluatesRhinoExpression(methodAccess, this.getExpr()) or
    compilesScript(methodAccess, this.getExpr()) or
    definesRhinoClass(methodAccess, this.getExpr())
  }

  /** An access to the method associated with this sink. */
  MethodCall getMethodCall() { result = methodAccess }
}

/**
 * A taint tracking configuration that tracks flow from `ActiveThreatModelSource` to an argument
 * of a method call that executes injected script.
 */
module ScriptInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof ScriptInjectionSink }
}

module ScriptInjectionFlow = TaintTracking::Global<ScriptInjectionConfig>;

deprecated query predicate problems(
  MethodCall sinkCall, ScriptInjectionFlow::PathNode source, ScriptInjectionFlow::PathNode sink,
  string message1, DataFlow::Node sourceNode, string message2
) {
  ScriptInjectionFlow::flowPath(source, sink) and
  sinkCall = sink.getNode().(ScriptInjectionSink).getMethodCall() and
  message1 = "Java Script Engine evaluate $@." and
  sourceNode = source.getNode() and
  message2 = "user input"
}
