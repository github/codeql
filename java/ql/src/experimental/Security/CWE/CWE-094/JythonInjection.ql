/**
 * @name Injection in Jython
 * @description Evaluation of a user-controlled malicious expression in Java Python
 *              interpreter may lead to remote code execution.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/jython-injection
 * @tags security
 *       experimental
 *       external/cwe/cwe-094
 *       external/cwe/cwe-095
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.frameworks.spring.SpringController
import CodeInjectionFlow::PathGraph

/** The class `org.python.util.PythonInterpreter`. */
class PythonInterpreter extends RefType {
  PythonInterpreter() { this.hasQualifiedName("org.python.util", "PythonInterpreter") }
}

/** A method that evaluates, compiles or executes a Jython expression. */
class InterpretExprMethod extends Method {
  InterpretExprMethod() {
    this.getDeclaringType().getAnAncestor*() instanceof PythonInterpreter and
    this.getName().matches(["exec%", "run%", "eval", "compile"])
  }
}

/** The class `org.python.core.BytecodeLoader`. */
class BytecodeLoader extends RefType {
  BytecodeLoader() { this.hasQualifiedName("org.python.core", "BytecodeLoader") }
}

/** Holds if a Jython expression if evaluated, compiled or executed. */
predicate runsCode(MethodCall ma, Expr sink) {
  exists(Method m | m = ma.getMethod() |
    m instanceof InterpretExprMethod and
    sink = ma.getArgument(0)
  )
}

/** A method that loads Java class data. */
class LoadClassMethod extends Method {
  LoadClassMethod() {
    this.getDeclaringType().getAnAncestor*() instanceof BytecodeLoader and
    this.hasName(["makeClass", "makeCode"])
  }
}

/**
 * Holds if `ma` is a call to a class-loading method, and `sink` is the byte array
 * representing the class to be loaded.
 */
predicate loadsClass(MethodCall ma, Expr sink) {
  exists(Method m, int i | m = ma.getMethod() |
    m instanceof LoadClassMethod and
    m.getParameter(i).getType() instanceof Array and // makeClass(java.lang.String name, byte[] data, ...)
    sink = ma.getArgument(i)
  )
}

/** The class `org.python.core.Py`. */
class Py extends RefType {
  Py() { this.hasQualifiedName("org.python.core", "Py") }
}

/** A method declared on class `Py` or one of its descendants that compiles Python code. */
class PyCompileMethod extends Method {
  PyCompileMethod() {
    this.getDeclaringType().getAnAncestor*() instanceof Py and
    this.getName().matches("compile%")
  }
}

/** Holds if source code is compiled with `PyCompileMethod`. */
predicate compile(MethodCall ma, Expr sink) {
  exists(Method m | m = ma.getMethod() |
    m instanceof PyCompileMethod and
    sink = ma.getArgument(0)
  )
}

/** An expression loaded by Jython. */
class CodeInjectionSink extends DataFlow::ExprNode {
  MethodCall methodAccess;

  CodeInjectionSink() {
    runsCode(methodAccess, this.getExpr()) or
    loadsClass(methodAccess, this.getExpr()) or
    compile(methodAccess, this.getExpr())
  }

  MethodCall getMethodCall() { result = methodAccess }
}

/**
 * A taint configuration for tracking flow from `ActiveThreatModelSource` to a Jython method call
 * `CodeInjectionSink` that executes injected code.
 */
module CodeInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof CodeInjectionSink }
}

/**
 * Taint tracking flow from `ActiveThreatModelSource` to a Jython method call
 * `CodeInjectionSink` that executes injected code.
 */
module CodeInjectionFlow = TaintTracking::Global<CodeInjectionConfig>;

deprecated query predicate problems(
  MethodCall sinkCall, CodeInjectionFlow::PathNode source, CodeInjectionFlow::PathNode sink,
  string message1, DataFlow::Node sourceNode, string message2
) {
  CodeInjectionFlow::flowPath(source, sink) and
  sinkCall = sink.getNode().(CodeInjectionSink).getMethodCall() and
  message1 = "Jython evaluate $@." and
  sourceNode = source.getNode() and
  message2 = "user input"
}
