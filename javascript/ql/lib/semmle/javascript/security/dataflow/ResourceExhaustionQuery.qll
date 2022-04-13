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
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "ResourceExhaustion" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node src, DataFlow::Node dst) {
    isNumericFlowStep(src, dst)
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof UpperBoundsCheckSanitizerGuard
  }

  override predicate isSanitizerEdge(DataFlow::Node pred, DataFlow::Node succ) {
    succ.(DataFlow::PropRead).accesses(pred, "length")
  }
}

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
