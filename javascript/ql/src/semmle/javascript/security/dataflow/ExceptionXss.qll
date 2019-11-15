/**
 * Provides a taint-tracking configuration for TODO:
 */

import javascript

module ExceptionXss {
  import Xss::DomBasedXss // imports sinks
  import DomBasedXssCustomizations::DomBasedXss // imports sources

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
    or
    // TODO: Do some flow label for deeply tainted objects?
    exists(DataFlow::ObjectLiteralNode obj |
      obj.asExpr().(ObjectExpr).getAProperty().getInit() = node.asExpr() and
      canThrowSensitiveInformation(obj)
    )
    or
    exists(DataFlow::ArrayCreationNode arr |
      arr.getAnElement() = node and
      canThrowSensitiveInformation(arr)
    )
  }

  TryStmt getEnclosingTryStmt(Stmt stmt) {
    stmt.getParentStmt+() = result.getBody() and
    not exists(TryStmt mid |
      stmt.getParentStmt+() = mid.getBody() and mid.getParentStmt+() = result.getBody()
    )
  }

  /**
   * A taint-tracking configuration for reasoning about XSS with possible exceptional flow.
   */
  abstract class BaseConfiguration extends TaintTracking::Configuration {
    BaseConfiguration() { this = "ExceptionXss" or this = "ExceptionXssNoException" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }

    override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
      succ = getExceptionalSuccssor(pred) and
      (
        canThrowSensitiveInformation(pred)
        or
        pred = any(DataFlow::FunctionNode func).getExceptionalReturn()
      )
    }
  }

  /**
   * Instantiation of BaseConfiguration. 
   */
  class Configuration extends BaseConfiguration {
    Configuration() { this = "ExceptionXss" }
  }

  /**
   * Same as configuration, except that all additional exceptional flows has been removed.
   */
  class ConfigurationNoException extends BaseConfiguration {
    ConfigurationNoException() { this = "ExceptionXssNoException" }

    override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
      super.isAdditionalTaintStep(pred, succ) and
      not succ = getExceptionalSuccssor(pred)
    }
  }
}
