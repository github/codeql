/**
 * @name Uncaught Servlet Exception
 * @description Uncaught exceptions in a servlet could leave a system in an
 *              unexpected state, possibly resulting in denial-of-service
 *              attacks or the exposure of sensitive information disclosed in
 *              stack traces.
 * @kind path-problem
 * @problem.severity warning
 * @precision medium
 * @id java/uncaught-servlet-exception
 * @tags security
 *       experimental
 *       external/cwe/cwe-600
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.frameworks.Servlets
import semmle.code.xml.WebXML
import UncaughtServletExceptionFlow::PathGraph

/** Holds if a given exception type is caught. */
private predicate exceptionIsCaught(TryStmt t, RefType exType) {
  exists(CatchClause cc, LocalVariableDeclExpr v |
    t.getACatchClause() = cc and
    cc.getVariable() = v and
    v.getType().(RefType).getADescendant() = exType and // Detect the case that a subclass exception is thrown but its parent class is declared in the catch clause.
    not exists(
      ThrowStmt ts // Detect the edge case that exception is caught then rethrown without processing in a catch clause
    |
      ts.getEnclosingStmt() = cc.getBlock() and
      ts.getExpr() = v.getAnAccess()
    )
  )
}

/** Servlet methods of `javax.servlet.http.Servlet` and subtypes. */
private predicate isServletMethod(Callable c) {
  c.getDeclaringType() instanceof ServletClass and
  c.getNumberOfParameters() = 2 and
  c.getParameter(1).getType() instanceof ServletResponse and
  c.getName() in [
      "doGet", "doPost", "doPut", "doDelete", "doHead", "doOptions", "doTrace", "service"
    ]
}

/** Holds if `web.xml` has an error page configured. */
private predicate hasErrorPage() {
  exists(WebErrorPage wep | wep.getPageLocation().getValue() != "")
}

/** Sink of uncaught exceptions, which shall be IO exceptions or runtime exceptions since other exception types must be explicitly caught. */
class UncaughtServletExceptionSink extends DataFlow::ExprNode {
  UncaughtServletExceptionSink() {
    exists(Method m, MethodCall ma | ma.getMethod() = m |
      isServletMethod(ma.getEnclosingCallable()) and
      exists(m.getAThrownExceptionType()) and // The called method might plausibly throw an exception.
      ma.getAnArgument() = this.getExpr() and
      not exists(TryStmt t |
        t.getBlock() = ma.getAnEnclosingStmt() and
        exceptionIsCaught(t, m.getAThrownExceptionType())
      )
    )
  }
}

/** Taint configuration of uncaught exceptions caused by user provided data from `ActiveThreatModelSource` */
module UncaughtServletExceptionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof UncaughtServletExceptionSink }
}

module UncaughtServletExceptionFlow = TaintTracking::Global<UncaughtServletExceptionConfig>;

deprecated query predicate problems(
  DataFlow::Node sinkNode, UncaughtServletExceptionFlow::PathNode source,
  UncaughtServletExceptionFlow::PathNode sink, string message1, DataFlow::Node sourceNode,
  string message2
) {
  UncaughtServletExceptionFlow::flowPath(source, sink) and
  not hasErrorPage() and
  sinkNode = sink.getNode() and
  message1 = "This value depends on a $@ and can throw uncaught exception." and
  sourceNode = source.getNode() and
  message2 = "user-provided value"
}
