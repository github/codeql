/**
 * @name Uncaught Servlet Exception
 * @description Uncaught exceptions in a servlet could leave a system in a vulnerable state, possibly resulting in denial-of-service attacks or the exposure of sensitive information disclosed in stack traces.
 * @kind path-problem
 * @id java/uncaught-servlet-exception
 * @tags security
 *       external/cwe-600
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.frameworks.Servlets
import DataFlow::PathGraph

/** The type `java.io.IOException`. */
class IOException extends RefType {
  IOException() { this.hasQualifiedName("java.io", "IOException") }
}

/** Check whether a given exception type is caught. */
private predicate catchesEx(TryStmt t, RefType exType) {
  exists(CatchClause cc, LocalVariableDeclExpr v |
    t.getACatchClause() = cc and
    cc.getVariable() = v and
    v.getType().(RefType).getASubtype*() = exType //Detect the case that a subclass exception is thrown but its parent class is declared in the catch clause.
  )
}

/** Servlet methods of `javax.servlet.http.HttpServlet`. */
private predicate isServletMethod(Callable c) {
  c.getDeclaringType() instanceof ServletClass and
  c.getNumberOfParameters() = 2 and
  c.getParameter(1).getType() instanceof HttpServletResponse and
  (
    c.getName() = "doGet" or
    c.getName() = "doPost" or
    c.getName() = "doPut" or
    c.getName() = "doDelete" or
    c.getName() = "doHead" or
    c.getName() = "doOptions" or
    c.getName() = "doTrace" or
    c.getName() = "service"
  )
}

/** Sink of uncaught IO exceptions or runtime exceptions since other exception types must be explicitly caught. */
class UncaughtServletExceptionSink extends DataFlow::ExprNode {
  UncaughtServletExceptionSink() {
    exists(Method m, MethodAccess ma | ma.getMethod() = m |
      isServletMethod(ma.getEnclosingCallable()) and
      (
        m.getAThrownExceptionType().getASupertype*() instanceof IOException or
        m
            .getAThrownExceptionType()
            .getASupertype*()
            .hasQualifiedName("java.lang", "RuntimeException")
      ) and
      ma.getAnArgument() = this.getExpr() and
      not exists(TryStmt t |
        t.getBlock() = ma.getEnclosingStmt().getEnclosingStmt*() and
        catchesEx(t, m.getAThrownExceptionType())
      )
    )
  }
}

class UncaughtServletExceptionConfiguration extends TaintTracking::Configuration {
  UncaughtServletExceptionConfiguration() { this = "UncaughtServletException" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UncaughtServletExceptionSink }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, UncaughtServletExceptionConfiguration c
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ flows to here and can throw uncaught exception.",
  source.getNode(), "User-provided value"
