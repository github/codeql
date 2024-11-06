/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * bypass of sensitive action guards, as well as extension points for
 * adding your own.
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
   * DEPRECATED: Use `ActiveThreatModelSource` from Concepts instead!
   */
  deprecated class RemoteFlowSourceAsSource = ActiveThreatModelSourceAsSource;

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source, ActiveThreatModelSource { }

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
