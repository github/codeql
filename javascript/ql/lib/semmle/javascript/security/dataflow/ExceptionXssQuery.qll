/**
 * Provides a taint-tracking configuration for reasoning about cross-site
 * scripting vulnerabilities where the taint-flow passes through a thrown
 * exception.
 */

import javascript
import DomBasedXssCustomizations::DomBasedXss as DomBasedXssCustom
import ReflectedXssCustomizations::ReflectedXss as ReflectedXssCustom
import ExceptionXssCustomizations::ExceptionXss
private import ExceptionXssCustomizations::ExceptionXss as ExceptionXss
private import semmle.javascript.dataflow.InferredTypes
import Xss::Shared as XssShared

/**
 * Gets the name of a method that does not leak taint from its arguments if an exception is thrown by the method.
 */
private string getAnUnlikelyToThrowMethodName() {
  result = "getElementById" or // document.getElementById
  result = "indexOf" or // String.prototype.indexOf
  result = "assign" or // Object.assign
  result = "pick" or // _.pick
  result = getAStandardLoggerMethodName() or // log.info etc.
  result = "val" or // $.val
  result = "parse" or // JSON.parse
  result = "stringify" or // JSON.stringify
  result = "test" or // RegExp.prototype.test
  result = "setItem" or // localStorage.setItem
  result = "existsSync" or
  // the "fs" methods are a mix of "this is safe" and "you have bigger problems".
  exists(ExternalMemberDecl decl | decl.hasQualifiedName("fs", result)) or
  // Array methods are generally exception safe.
  exists(ExternalMemberDecl decl | decl.hasQualifiedName("Array", result))
}

/**
 * Holds if `node` is unlikely to cause an exception containing sensitive information to be thrown.
 */
private predicate isUnlikelyToThrowSensitiveInformation(DataFlow::Node node) {
  node =
    any(DataFlow::CallNode call | call.getCalleeName() = getAnUnlikelyToThrowMethodName())
        .getAnArgument()
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
  not node instanceof XssShared::Sink and // removes duplicates from js/xss.
  (
    // in the case of reflective calls the below ensures that both InvokeNodes have no known callee.
    forex(DataFlow::InvokeNode call | call.getAnArgument() = node | not exists(call.getACallee()))
    or
    node.asExpr().getEnclosingStmt() instanceof ThrowStmt
    or
    exists(DataFlow::PropRef prop |
      node = DataFlow::valueNode(prop.getPropertyNameExpr()) and
      forex(InferredType t | t = prop.getBase().analyze().getAType() | isNullOrUndefined(t))
    )
  )
}

// Materialize flow labels
deprecated private class ConcreteNotYetThrown extends NotYetThrown {
  ConcreteNotYetThrown() { this = this }
}

/**
 * A callback that is the last argument to some call, and the callback has the form:
 * `function (err, value) {if (err) {...} ... }`
 */
class Callback extends DataFlow::FunctionNode {
  DataFlow::ParameterNode errorParameter;

  Callback() {
    exists(DataFlow::CallNode call | call.getLastArgument().getAFunctionValue() = this) and
    this.getNumParameter() = 2 and
    errorParameter = this.getParameter(0) and
    exists(IfStmt ifStmt |
      ifStmt = this.getFunction().getBodyStmt(0) and
      errorParameter.flowsToExpr(ifStmt.getCondition())
    )
  }

  /**
   * Gets the parameter in the callback that contains an error.
   * In the current implementation this is always the first parameter.
   */
  DataFlow::Node getErrorParam() { result = errorParameter }
}

/**
 * Gets the error parameter for a callback that is supplied to the same call as `pred` is an argument to.
 * For example: `outerCall(foo, <pred>, bar, (<result>, val) => { ... })`.
 */
DataFlow::Node getCallbackErrorParam(DataFlow::Node pred) {
  exists(DataFlow::CallNode call, Callback callback |
    pred = call.getAnArgument() and
    call.getLastArgument() = callback and
    result = callback.getErrorParam() and
    not pred = callback
  )
}

/**
 * Gets the data-flow node to which any exceptions thrown by
 * this expression will propagate.
 * This predicate adds, on top of `Expr::getExceptionTarget`, exceptions
 * propagated by callbacks.
 */
private DataFlow::Node getExceptionTarget(DataFlow::Node pred) {
  result = pred.asExpr().getExceptionTarget()
  or
  result = getCallbackErrorParam(pred)
}

/**
 * A taint-tracking configuration for reasoning about XSS with possible exceptional flow.
 * Flow states are used to ensure that we only report taint-flow that has been thrown in
 * an exception.
 */
module ExceptionXssConfig implements DataFlow::StateConfigSig {
  class FlowState = ExceptionXss::FlowState;

  predicate isSource(DataFlow::Node source, FlowState state) {
    source.(Source).getAFlowState() = state
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    sink instanceof XssShared::Sink and not state = FlowState::notYetThrown()
  }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof XssShared::Sanitizer or node = XssShared::BarrierGuard::getABarrierNode()
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    state1 = FlowState::notYetThrown() and
    state2 = [FlowState::thrown(), FlowState::notYetThrown()] and
    canThrowSensitiveInformation(node1) and
    node2 = getExceptionTarget(node1)
  }

  int accessPathLimit() { result = 1 }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for reasoning about XSS with possible exceptional flow.
 */
module ExceptionXssFlow = TaintTracking::GlobalWithState<ExceptionXssConfig>;

/**
 * DEPRECATED. Use the `ExceptionXssFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "ExceptionXss" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    source.(Source).getAFlowLabel() = label
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    sink instanceof XssShared::Sink and not label instanceof NotYetThrown
  }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof XssShared::Sanitizer }

  override predicate isAdditionalFlowStep(
    DataFlow::Node pred, DataFlow::Node succ, DataFlow::FlowLabel inlbl, DataFlow::FlowLabel outlbl
  ) {
    ExceptionXssConfig::isAdditionalFlowStep(pred, FlowState::fromFlowLabel(inlbl), succ,
      FlowState::fromFlowLabel(outlbl))
    or
    // All the usual taint-flow steps apply on data-flow before it has been thrown in an exception.
    // Note: this step is not needed in StateConfigSig module since flow states inherit taint steps.
    this.isAdditionalFlowStep(pred, succ) and
    inlbl instanceof NotYetThrown and
    outlbl instanceof NotYetThrown
  }
}
