/**
 * Provides a taint tracking configuration for reasoning about
 * resource exhaustion vulnerabilities (CWE-770).
 *
 * Note, for performance reasons: only import this file if
 * `ResourceExhaustion::Configuration` is needed, otherwise
 * `ResourceExhaustionCustomizations` should be imported instead.
 */

import javascript
import semmle.javascript.security.dataflow.LoopBoundInjectionCustomizations

module ResourceExhaustion {
  import ResourceExhaustionCustomizations::ResourceExhaustion

  /**
   * A data flow configuration for resource exhaustion vulnerabilities.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "ResourceExhaustion" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isAdditionalTaintStep(DataFlow::Node src, DataFlow::Node dst) {
      isNumericFlowStep(src, dst)
      or
      // reuse most existing taint steps
      isRestrictedAdditionalTaintStep(src, dst)
    }

    override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
      guard instanceof LoopBoundInjection::LengthCheckSanitizerGuard or
      guard instanceof UpperBoundsCheckSanitizerGuard
    }
  }

  predicate isRestrictedAdditionalTaintStep(DataFlow::Node src, DataFlow::Node dst) {
    TaintTracking::sharedTaintStep(src, dst) and
    not dst.asExpr() instanceof AddExpr and
    not dst.(DataFlow::MethodCallNode).calls(src, "toString")
  }

  /**
   * Holds if data may flow from `src` to `dst` as a number.
   */
  predicate isNumericFlowStep(DataFlow::Node src, DataFlow::Node dst) {
    // steps that introduce or preserve a number
    dst.(DataFlow::PropRead).accesses(src, ["length", "size"])
    or
    exists(DataFlow::CallNode c |
      c = dst and
      src = c.getAnArgument()
    |
      c = DataFlow::globalVarRef("Math").getAMemberCall(_) or
      c = DataFlow::globalVarRef(["Number", "parseInt", "parseFloat"]).getACall()
    )
    or
    exists(Expr dstExpr, Expr srcExpr |
      dstExpr = dst.asExpr() and
      srcExpr = src.asExpr()
    |
      dstExpr.(BinaryExpr).getAnOperand() = srcExpr and
      not dstExpr instanceof AddExpr
      or
      dstExpr.(PlusExpr).getOperand() = srcExpr
    )
  }
}
