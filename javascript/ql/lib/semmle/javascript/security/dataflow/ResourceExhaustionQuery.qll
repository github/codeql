/**
 * Provides a taint tracking configuration for reasoning about
 * resource exhaustion vulnerabilities (CWE-770).
 *
 * Note, for performance reasons: only import this file if
 * `ResourceExhaustion::Configuration` is needed, otherwise
 * `ResourceExhaustionCustomizations` should be imported instead.
 */

import javascript
import ResourceExhaustionCustomizations::ResourceExhaustion

/**
 * A data flow configuration for resource exhaustion vulnerabilities.
 */
module ResourceExhaustionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof Sanitizer or
    node = any(DataFlow::PropRead read | read.getPropertyName() = "length") or
    node = DataFlow::MakeBarrierGuard<BarrierGuard>::getABarrierNode()
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    isNumericFlowStep(node1, node2)
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Data flow for resource exhaustion vulnerabilities.
 */
module ResourceExhaustionFlow = TaintTracking::Global<ResourceExhaustionConfig>;

/** Holds if data is converted to a number from `src` to `dst`. */
predicate isNumericFlowStep(DataFlow::Node src, DataFlow::Node dst) {
  exists(DataFlow::CallNode c |
    c = dst and
    src = c.getAnArgument()
  |
    c = DataFlow::globalVarRef("Math").getAMemberCall(_) or
    c = DataFlow::globalVarRef(["Number", "parseInt", "parseFloat"]).getACall()
  )
}

/**
 * A sanitizer that blocks taint flow if the size of a number is limited.
 */
class UpperBoundsCheckSanitizerGuard extends BarrierGuard, DataFlow::ValueNode {
  override RelationalComparison astNode;

  override predicate blocksExpr(boolean outcome, Expr e) {
    true = outcome and
    e = astNode.getLesserOperand()
    or
    false = outcome and
    e = astNode.getGreaterOperand()
  }
}
