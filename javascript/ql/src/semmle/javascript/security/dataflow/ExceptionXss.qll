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

  DataFlow::Node getExceptionalSuccssor(DataFlow::Node pred) {
    exists(DataFlow::FunctionNode func |
      pred.getContainer() = func.getFunction() and
      if exists(getEnclosingTryStmt(pred.asExpr().getEnclosingStmt()))
      then
        result.(DataFlow::ParameterNode).getParameter() = getEnclosingTryStmt(pred
                .asExpr()
                .getEnclosingStmt()).getACatchClause().getAParameter()
      else result = getExceptionalSuccssor(func.getExceptionalReturn())
      or
      pred = func.getExceptionalReturn() and
      exists(DataFlow::InvokeNode call |
        not call.isImprecise() and
        func.getFunction() = call.(DataFlow::InvokeNode).getACallee() and
        result = getExceptionalSuccssor(call)
      )
    )
  }

  predicate canThrowSensitiveInformation(DataFlow::Node node) {
    // i have to do this "dual" check because there are two data-flow nodes associated with reflective calls.
    node = any(DataFlow::InvokeNode call).getAnArgument() and
    not node = any(DataFlow::InvokeNode call | exists(call.getACallee())).getAnArgument()
    or
    node.asExpr().getEnclosingStmt() instanceof ThrowStmt
  }

  TryStmt getEnclosingTryStmt(Stmt stmt) {
    stmt.getParentStmt+() = result.getBody() and
    not exists(TryStmt mid |
      stmt.getParentStmt+() = mid.getBody() and mid.getParentStmt+() = result.getBody()
    )
  }
  
  class NotYetThrown extends DataFlow::FlowLabel {
    NotYetThrown() { this = "NotYetThrown" }
  }

  /**
   * A taint-tracking configuration for reasoning about XSS with possible exceptional flow.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "ExceptionXss"}

    override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
      source instanceof XSS::Shared::Source and label instanceof NotYetThrown
    }
    
    override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
   	  sink instanceof XSS::Shared::Sink and label.isDataOrTaint()
   	}

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof XSS::Shared::Sanitizer
    }

    override predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ, DataFlow::FlowLabel inlbl, DataFlow::FlowLabel outlbl) {
      this.isAdditionalFlowStep(pred, succ) and inlbl instanceof NotYetThrown and outlbl instanceof NotYetThrown 
      or
      inlbl instanceof NotYetThrown and outlbl.isTaint() and
      succ = getExceptionalSuccssor(pred) and
      canThrowSensitiveInformation(pred)
      or  
      inlbl instanceof NotYetThrown and outlbl instanceof NotYetThrown and
      exists(DataFlow::PropWrite write | write.getRhs() = pred and write.getBase() = succ)
    }
  }
}
