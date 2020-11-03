/**
 * @name Uncaught Servlet Exception
 * @description Uncaught exceptions in a servlet could leave a system in an unexpected state, possibly resulting in denial-of-service attacks or the exposure of sensitive information disclosed in stack traces.
 * @kind path-problem
 * @id java/uncaught-servlet-exception
 * @tags security
 *       external/cwe-600
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.DataFlow2
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.frameworks.Servlets
import semmle.code.xml.WebXML
import DataFlow::PathGraph

/** DataFlow configuration for detecting the case of rethrowing unprocessed exceptions */
class ThrowExConfiguration extends DataFlow2::Configuration {
  ThrowExConfiguration() { this = "Throwing Unprocessed Exception Configuration" }

  /** Source of `LocalVariableDeclExpr` */
  override predicate isSource(DataFlow::Node source) {
    exists(LocalVariableDeclExpr v | source.asExpr() = v.getAnAccess())
  }

  /** Sink of `ThrowStmt` */
  override predicate isSink(DataFlow::Node sink) {
    exists(ThrowStmt ts | sink.asExpr() = ts.getExpr()) // e.g. the uhex exception throwed in `catch (UnknownHostException uhex) {throw uhex;}`
  }

  /**
   * Holds if there are additional flow steps below:
   *  new IOException(uhex);
   *  IOException ioException = new IOException(); ioException.initCause(e); throw ioException;
   *  IOException ioException = new IOException(); ioException.addSuppressed(e); throw ioException;
   */
  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(ClassInstanceExpr cie | node1.asExpr() = cie.getAnArgument() and node2.asExpr() = cie) // catch (UnknownHostException uhex) {throw new IOException(uhex);}
    or
    exists(
      MethodAccess ma // e.g. IOException ioException = new IOException(); ioException.addSuppressed(e); throw ioException;
    |
      ma.getMethod().getName() in ["initCause", "addSuppressed"] and
      node1.asExpr() = ma.getAnArgument() and
      (
        node2.asExpr() = ma.getQualifier() or
        node2.asExpr() = ma
      )
    )
  }
}

/** Holds if a given exception type is caught. */
private predicate exceptionIsCaught(TryStmt t, RefType exType) {
  exists(CatchClause cc, LocalVariableDeclExpr v |
    t.getACatchClause() = cc and
    cc.getVariable() = v and
    v.getType().(RefType).getASubtype*() = exType and // Detect the case that a subclass exception is thrown but its parent class is declared in the catch clause.
    not exists(
      ThrowStmt ts // Detect the edge case that exception is caught then rethrown without processing in a catch clause
    |
      ts.getEnclosingStmt() = cc.getBlock() and
      exists(ThrowExConfiguration tec |
        tec.hasFlow(DataFlow::exprNode(v.getAnAccess()), DataFlow::exprNode(ts.getExpr()))
      )
    )
  )
}

/** Servlet methods of `javax.servlet.http.Servlet` and subtypes. */
private predicate isServletMethod(Callable c) {
  c.getDeclaringType() instanceof ServletClass and
  c.getNumberOfParameters() = 2 and
  c.getParameter(1).getType() instanceof ServletResponse and
  c.getName() in ["doGet", "doPost", "doPut", "doDelete", "doHead", "doOptions", "doTrace",
        "service"]
}

/** Holds if `web.xml` has an error page configured. */
private predicate hasErrorPage() {
  exists(WebErrorPage wep | wep.getPageLocation().getValue() != "")
}

/** Sink of uncaught exceptions, which shall be IO exceptions or runtime exceptions since other exception types must be explicitly caught. */
class UncaughtServletExceptionSink extends DataFlow::ExprNode {
  UncaughtServletExceptionSink() {
    exists(Method m, MethodAccess ma | ma.getMethod() = m |
      isServletMethod(ma.getEnclosingCallable()) and
      ma.getAnArgument() = this.getExpr() and
      not exists(TryStmt t |
        t.getBlock() = ma.getEnclosingStmt().getEnclosingStmt*() and
        exceptionIsCaught(t, m.getAThrownExceptionType())
      )
    )
  }
}

/** Taint configuration of uncaught exceptions caused by user provided data from `RemoteFlowSource` */
class UncaughtServletExceptionConfiguration extends TaintTracking::Configuration {
  UncaughtServletExceptionConfiguration() { this = "UncaughtServletException" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UncaughtServletExceptionSink }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, UncaughtServletExceptionConfiguration c
where c.hasFlowPath(source, sink) and not hasErrorPage()
select sink.getNode(), source, sink, "$@ flows to here and can throw uncaught exception.",
  source.getNode(), "User-provided value"
