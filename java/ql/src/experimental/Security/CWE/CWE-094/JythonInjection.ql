/**
 * @name Injection in Jython
 * @description Evaluation of a user-controlled malicious expression in Java Python
 *              interpreter may lead to remote code execution.
 * @kind path-problem
 * @id java/jython-injection
 * @tags security
 *       external/cwe/cwe-094
 *       external/cwe/cwe-095
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.frameworks.spring.SpringController
import DataFlow::PathGraph

/** The class `org.python.util.PythonInterpreter`. */
class PythonInterpreter extends RefType {
  PythonInterpreter() { this.hasQualifiedName("org.python.util", "PythonInterpreter") }
}

/** A method that evaluates, compiles or executes a Jython expression. */
class InterpretExprMethod extends Method {
  InterpretExprMethod() {
    this.getDeclaringType().getAnAncestor*() instanceof PythonInterpreter and
    getName().matches(["exec%", "run%", "eval", "compile"])
  }
}

/** The class `org.python.core.BytecodeLoader`. */
class BytecodeLoader extends RefType {
  BytecodeLoader() { this.hasQualifiedName("org.python.core", "BytecodeLoader") }
}

/** Holds if a Jython expression if evaluated, compiled or executed. */
predicate runCode(MethodAccess ma, Expr sink) {
  exists(Method m | m = ma.getMethod() |
    m instanceof InterpretExprMethod and
    sink = ma.getArgument(0)
  )
}

/** A method that loads Java class data. */
class LoadClassMethod extends Method {
  LoadClassMethod() {
    this.getDeclaringType().getAnAncestor*() instanceof BytecodeLoader and
    hasName(["makeClass", "makeCode"])
  }
}

/**
 * Holds if `ma` is a call to a class-loading method, and `sink` is the byte array
 * representing the class to be loaded.
 */
predicate loadClass(MethodAccess ma, Expr sink) {
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
    getName().matches("compile%")
  }
}

/** Holds if source code is compiled with `PyCompileMethod`. */
predicate compile(MethodAccess ma, Expr sink) {
  exists(Method m | m = ma.getMethod() |
    m instanceof PyCompileMethod and
    sink = ma.getArgument(0)
  )
}

/** An expression loaded by Jython. */
class CodeInjectionSink extends DataFlow::ExprNode {
  CodeInjectionSink() {
    runCode(_, this.getExpr()) or
    loadClass(_, this.getExpr()) or
    compile(_, this.getExpr())
  }

  MethodAccess getMethodAccess() {
    runCode(result, this.getExpr()) or
    loadClass(result, this.getExpr()) or
    compile(result, this.getExpr())
  }
}

class CodeInjectionConfiguration extends TaintTracking::Configuration {
  CodeInjectionConfiguration() { this = "CodeInjectionConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof CodeInjectionSink }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    // @RequestBody MyQueryObj query; interpreter.exec(query.getInterpreterCode());
    exists(MethodAccess ma |
      ma.getMethod().getDeclaringType().getASubtype*() instanceof SpringUntrustedDataType and
      not ma.getMethod().getDeclaringType() instanceof TypeObject and
      ma.getQualifier() = node1.asExpr() and
      ma = node2.asExpr()
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, CodeInjectionConfiguration conf
where conf.hasFlowPath(source, sink)
select sink.getNode().(CodeInjectionSink).getMethodAccess(), source, sink, "Jython evaluate $@.",
  source.getNode(), "user input"
