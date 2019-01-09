/**
 * Provides a taint tracking configuration for reasoning about bypass of sensitive action guards.
 */

import javascript
private import semmle.javascript.security.SensitiveActions

module ConditionalBypass {
  /**
   * A data flow source for bypass of sensitive action guards.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for bypass of sensitive action guards.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets the guarded sensitive action.
     */
    abstract SensitiveAction getAction();
  }

  /**
   * A sanitizer for bypass of sensitive action guards.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A taint tracking configuration for bypass of sensitive action guards.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "ConditionalBypass" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }

    override predicate isAdditionalTaintStep(DataFlow::Node src, DataFlow::Node dst) {
      // comparing a tainted expression against a constant gives a tainted result
      dst.asExpr().(Comparison).hasOperands(src.asExpr(), any(ConstantExpr c))
    }
  }

  /**
   * A source of remote user input, considered as a flow source for bypass of
   * sensitive action guards.
   */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }

  /**
   * Holds if `bb` dominates the basic block in which `action` occurs.
   */
  private predicate dominatesSensitiveAction(ReachableBasicBlock bb, SensitiveAction action) {
    bb = action.getBasicBlock()
    or
    exists(ReachableBasicBlock mid |
      dominatesSensitiveAction(mid, action) and
      bb = mid.getImmediateDominator()
    )
  }

  /**
   * A conditional that guards a sensitive action, e.g. `ok` in `if (ok) login()`.
   */
  class SensitiveActionGuardConditional extends Sink {
    SensitiveAction action;

    SensitiveActionGuardConditional() {
      exists(GuardControlFlowNode guard |
        this.asExpr() = guard.getTest() and
        dominatesSensitiveAction(guard.getBasicBlock(), action)
      )
    }

    override SensitiveAction getAction() { result = action }
  }
}
