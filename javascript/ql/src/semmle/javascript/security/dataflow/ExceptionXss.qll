/**
 * Provides a taint-tracking configuration for reasoning about cross-site
 * scripting vulnerabilities where the taint-flow passes through a thrown
 * exception.
 */

import javascript

module ExceptionXss {
  import DomBasedXssCustomizations::DomBasedXss as DomBasedXssCustom
  import ReflectedXssCustomizations::ReflectedXss as ReflectedXssCustom
  import Xss as Xss
  
  /**
   * Holds if `node` is unlikely to cause an exception containing sensitive information to be thrown.
   */
  private predicate isUnlikelyToThrowSensitiveInformation(DataFlow::Node node) {
    node = any(DataFlow::CallNode call | call.getCalleeName() = "getElementById").getAnArgument()
    or
    node = any(DataFlow::CallNode call | call.getCalleeName() = "indexOf").getAnArgument()
    or
    node = any(DataFlow::CallNode call | call.getCalleeName() = "stringify").getAnArgument()
    or
    node = DataFlow::globalVarRef("console").getAMemberCall(_).getAnArgument()
  }

  /**
   * Holds if `node` can possibly cause an exception containing sensitive information to be thrown.
   */
  predicate canThrowSensitiveInformation(DataFlow::Node node) {
    not isUnlikelyToThrowSensitiveInformation(node) and 
    (
      // in the case of reflective calls the below ensures that both InvokeNodes have no known callee.
      forex(DataFlow::InvokeNode call | node = call.getAnArgument() | not exists(call.getACallee()))
      or
      node.asExpr().getEnclosingStmt() instanceof ThrowStmt
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
    Configuration() { this = "ExceptionXss" }

    override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
      source instanceof Xss::Shared::Source and label instanceof NotYetThrown
    }

    override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
      sink instanceof Xss::Shared::Sink and not label instanceof NotYetThrown
    }

    override predicate isSanitizer(DataFlow::Node node) { node instanceof Xss::Shared::Sanitizer }

    override predicate isAdditionalFlowStep(
      DataFlow::Node pred, DataFlow::Node succ, DataFlow::FlowLabel inlbl,
      DataFlow::FlowLabel outlbl
    ) {
      inlbl instanceof NotYetThrown and (outlbl.isTaint() or outlbl instanceof NotYetThrown) and
      succ = pred.asExpr().getExceptionTarget() and
      canThrowSensitiveInformation(pred)
      or
      // All the usual taint-flow steps apply on data-flow before it has been thrown in an exception.
      this.isAdditionalFlowStep(pred, succ) and inlbl instanceof NotYetThrown and outlbl instanceof NotYetThrown
    }
  }
}
