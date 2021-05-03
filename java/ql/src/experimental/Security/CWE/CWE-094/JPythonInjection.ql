/**
 * @name Injection in JPython
 * @description Evaluation of a user-controlled malicious expression in JPython
 *              may lead to remote code execution.
 * @kind path-problem
 * @id java/jpython-injection
 * @tags security
 *       external/cwe/cwe-094
 *       external/cwe/cwe-095
 */

import java
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

/** The class `org.python.util.PythonInterpreter`. */
class PythonInterpreter extends RefType {
  PythonInterpreter() { this.hasQualifiedName("org.python.util", "PythonInterpreter") }
}

/** A method that evaluates, compiles or executes a JPython expression. */
class InterpretExprMethod extends Method {
  InterpretExprMethod() {
    this.getDeclaringType().getAnAncestor*() instanceof PythonInterpreter and
    (
      hasName("exec") or
      hasName("eval") or
      hasName("compile")
    )
  }
}

/** Holds if a JPython expression if evaluated, compiled or executed. */
predicate runCode(MethodAccess ma, Expr sink) {
  exists(Method m | m = ma.getMethod() |
    m instanceof InterpretExprMethod and
    sink = ma.getArgument(0)
  )
}

/** Sink of an expression interpreted by JPython interpreter. */
class CodeInjectionSink extends DataFlow::ExprNode {
  CodeInjectionSink() { runCode(_, this.getExpr()) }

  MethodAccess getMethodAccess() { runCode(result, this.getExpr()) }
}

class CodeInjectionConfiguration extends TaintTracking::Configuration {
  CodeInjectionConfiguration() { this = "CodeInjectionConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource
    or
    source instanceof LocalUserInput
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof CodeInjectionSink }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    // @RequestBody MyQueryObj query; interpreter.exec(query.getInterpreterCode());
    exists(MethodAccess ma | ma.getQualifier() = node1.asExpr() and ma = node2.asExpr())
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, CodeInjectionConfiguration conf
where conf.hasFlowPath(source, sink)
select sink.getNode().(CodeInjectionSink).getMethodAccess(), source, sink, "JPython evaluate $@.",
  source.getNode(), "user input"
