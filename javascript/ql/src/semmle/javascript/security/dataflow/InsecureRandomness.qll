/**
 * Provides a taint tracking configuration for reasoning about random
 * values that are not cryptographically secure.
 *
 * Note, for performance reasons: only import this file if
 * `InsecureRandomness::Configuration` is needed, otherwise
 * `InsecureRandomnessCustomizations` should be imported instead.
 */

import javascript
private import semmle.javascript.security.SensitiveActions

module InsecureRandomness {
  import InsecureRandomnessCustomizations::InsecureRandomness

  /**
   * A taint tracking configuration for random values that are not cryptographically secure.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "InsecureRandomness" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      // not making use of `super.isSanitizer`: those sanitizers are not for this kind of data
      node instanceof Sanitizer
    }

    override predicate isSanitizerEdge(DataFlow::Node pred, DataFlow::Node succ) {
      // stop propagation at the sinks to avoid double reporting
      pred instanceof Sink and
      // constrain succ
      pred = succ.getAPredecessor()
    }

    override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
      // Assume that all operations on tainted values preserve taint: crypto is hard
      succ.asExpr().(BinaryExpr).getAnOperand() = pred.asExpr()
      or
      succ.asExpr().(UnaryExpr).getOperand() = pred.asExpr()
      or
      exists(DataFlow::MethodCallNode mc |
        mc = DataFlow::globalVarRef("Math").getAMemberCall(_) and
        pred = mc.getAnArgument() and
        succ = mc
      )
    }
  }
}
