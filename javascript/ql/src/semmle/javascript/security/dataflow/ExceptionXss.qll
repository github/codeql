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
  private import semmle.javascript.dataflow.InferredTypes

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
   * Holds if `t` is `null` or `undefined`.
   */
  private predicate isNullOrUndefined(InferredType t) {
    t = TTNull() or
    t = TTUndefined()
  }

  /**
   * Holds if `node` can possibly cause an exception containing sensitive information to be thrown.
   */
  predicate canThrowSensitiveInformation(DataFlow::Node node) {
    not isUnlikelyToThrowSensitiveInformation(node) and
    (
      // in the case of reflective calls the below ensures that both InvokeNodes have no known callee.
      forex(DataFlow::InvokeNode call | call = getEnclosingCallNode(node) |
        not exists(call.getACallee())
      )
      or
      node.asExpr().getEnclosingStmt() instanceof ThrowStmt
      or
      exists(DataFlow::PropRef prop |
        node.getEnclosingExpr() = prop.getPropertyNameExpr() and
        isNullOrUndefined(prop.getBase().analyze().getAType())
      )
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

  // Consider using "if (err) {.. [do something with err] .. }" as an extra condition if there are too many FP's.
  class Callback extends DataFlow::FunctionNode {
    Callback() {
      exists(DataFlow::CallNode call | call.getLastArgument().getAFunctionValue() = this) and
      this.getNumParameter() = 2 and
      this.getParameter(0).getName().regexpMatch("err.*") // Using "e" was considered. But that matches too many jQuery methods where "element" is shortened as "e".
    }

    DataFlow::Node getErrorParam() { result = this.getParameter(0) }
  }

  DataFlow::CallNode getEnclosingCallNode(DataFlow::Node node) {
    result.getEnclosingExpr() = getEnclosingCall(node.getEnclosingExpr())
  }

  InvokeExpr getEnclosingCall(Expr e) {
    exists(Expr arg | arg = result.getAnArgument() |
      e.getParentExpr*() = arg and
      not exists(Expr mid | mid = any(InvokeExpr i) or mid = any(Function f) |
        e.getParentExpr+() = mid and mid.getParentExpr+() = result
      )
    )
  }

  // `someFunction(.. <pred> .., (<result>, value) => {...}).
  DataFlow::Node getCallbackErrorParam(DataFlow::Node pred) {
    exists(DataFlow::CallNode call, Callback callback |
      getEnclosingCallNode(pred) = call and
      call.getLastArgument() = callback and
      result = callback.getErrorParam() and
      not pred = callback
    )
  }

  /**
   * Gets the DataFlow::Node where an exception would flow to if `pred` is used in some context
   * where an exception could potentially be thrown.
   */
  DataFlow::Node getWhereExceptionWouldFlow(DataFlow::Node pred) {
    result = pred.asExpr().getExceptionTarget()
    or
    result = getCallbackErrorParam(pred)
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

    cached
    override predicate isAdditionalFlowStep(
      DataFlow::Node pred, DataFlow::Node succ, DataFlow::FlowLabel inlbl,
      DataFlow::FlowLabel outlbl
    ) {
      inlbl instanceof NotYetThrown and
      (outlbl.isTaint() or outlbl instanceof NotYetThrown) and
      canThrowSensitiveInformation(pred) and
      succ = getWhereExceptionWouldFlow(pred)
      or
      // All the usual taint-flow steps apply on data-flow before it has been thrown in an exception.
      this.isAdditionalFlowStep(pred, succ) and
      inlbl instanceof NotYetThrown and
      outlbl instanceof NotYetThrown
    }
  }
}
