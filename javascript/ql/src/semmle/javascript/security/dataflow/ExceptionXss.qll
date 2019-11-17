/**
 * Provides a taint-tracking configuration for reasoning about cross-site 
 * scripting vulnerabilities where the taint-flow passes through a thrown 
 * exception. 
 */

import javascript

module ExceptionXss {
  import DomBasedXssCustomizations::DomBasedXss as DomBasedXssCustom
  import ReflectedXssCustomizations::ReflectedXss as ReflectedXssCustom 
  import Xss::DomBasedXss as DomBasedXss 
  import Xss::ReflectedXss as ReflectedXSS
  import Xss::StoredXss as StoredXss
  import Xss as XSS

  DataFlow::ExceptionalInvocationReturnNode getCallerExceptionalReturn(Function func) {
    exists(DataFlow::InvokeNode call |
      not call.isImprecise() and
      func = call.getACallee() and
      result = call.getExceptionalReturn()
    )
  }

  DataFlow::Node getExceptionalSuccessor(DataFlow::Node pred) {
    if exists(getEnclosingTryStmt(pred.asExpr().getEnclosingStmt()))
    then
      result = DataFlow::parameterNode(getEnclosingTryStmt(pred
              .asExpr()
              .getEnclosingStmt()).getACatchClause().getAParameter())
    else result = getCallerExceptionalReturn(pred.getContainer())
  }

  predicate canThrowSensitiveInformation(DataFlow::Node node) {
    // in the case of reflective calls the below ensures that both InvokeNodes have no known callee.
    forex(DataFlow::InvokeNode call | node = call.getAnArgument() | not exists(call.getACallee()))
    or
    node.asExpr().getEnclosingStmt() instanceof ThrowStmt
  }

  TryStmt getEnclosingTryStmt(Stmt stmt) {
    stmt.getParentStmt+() = result.getBody() and
    not exists(TryStmt mid |
      stmt.getParentStmt+() = mid.getBody() and mid.getParentStmt+() = result.getBody()
    )
  }
  
  /**
   * A FlowLabel representing tainted data that has not been thrown in an exception. 
   * In the js/xss-through-exception query data-flow can only reach a sink after
   * the data has been thrown as an exception, and data that has not been thrown 
   * as an exception therefore has this flow label, and only this flow label, associated with it. 
   */
  class NotYetThrown extends DataFlow::FlowLabel {
    NotYetThrown() { this = "NotYetThrown" }
  }

  /**
   * A taint-tracking configuration for reasoning about XSS with possible exceptional flow. 
   * Flow labels are used to ensure that we only report taint-flow that has been thrown in 
   * an exception.  
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "ExceptionXss"}

    override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
      source instanceof XSS::Shared::Source and label instanceof NotYetThrown
    }
    
    override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
      sink instanceof XSS::Shared::Sink and not label instanceof NotYetThrown
    }

    override predicate isSanitizer(DataFlow::Node node) {
      node instanceof XSS::Shared::Sanitizer
    }

    override predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ, DataFlow::FlowLabel inlbl, DataFlow::FlowLabel outlbl) {
      inlbl instanceof NotYetThrown and (outlbl.isTaint() or outlbl instanceof NotYetThrown) and
      succ = getExceptionalSuccessor(pred) and
      (canThrowSensitiveInformation(pred) or pred = any(DataFlow::InvokeNode c).getExceptionalReturn())
      or
      // All the usual taint-flow steps apply on data-flow before it has been thrown in an exception.
      this.isAdditionalFlowStep(pred, succ) and inlbl instanceof NotYetThrown and outlbl instanceof NotYetThrown 
      or
      // We taint an object deep if it happens before an exception has been thrown. 
      inlbl instanceof NotYetThrown and outlbl instanceof NotYetThrown and
      exists(DataFlow::PropWrite write | write.getRhs() = pred and write.getBase() = succ)
    }
  }
}
