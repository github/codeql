/**
 * @name User-controlled bypass of security check
 * @description Conditions that the user controls are not suited for making security-related decisions.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id js/user-controlled-bypass
 * @tags security
 *       external/cwe/cwe-807
 *       external/cwe/cwe-290
 */
import javascript
import semmle.javascript.security.dataflow.ConditionalBypass::ConditionalBypass

/**
 * Holds if the value of `nd` flows into `guard`.
 */
predicate flowsToGuardExpr(DataFlow::Node nd, SensitiveActionGuardConditional guard) {
  nd = guard or
  flowsToGuardExpr(nd.getASuccessor(), guard)
}

/**
 * A comparison that guards a sensitive action, e.g. the comparison in:
 * `var ok = x == y; if (ok) login()`.
 */
class SensitiveActionGuardComparison extends Comparison {

  SensitiveActionGuardConditional guard;

  SensitiveActionGuardComparison() {
    flowsToGuardExpr(DataFlow::valueNode(this), guard)
  }

  /**
   * Gets the guard that uses this comparison.
   */
  SensitiveActionGuardConditional getGuard() {
    result = guard
  }

}

/**
 * An intermediary sink to enable reuse of the taint configuration.
 * This sink should not be presented to the client of this query.
 */
class SensitiveActionGuardComparisonOperand extends Sink {

  SensitiveActionGuardComparison comparison;

  SensitiveActionGuardComparisonOperand() {
    asExpr() = comparison.getAnOperand()
  }

  override SensitiveAction getAction() {
    result = comparison.getGuard().getAction()
  }

}

/**
 * Holds if `sink` guards `action`, and `source` taints `sink`.
 *
 * If flow from `source` taints `sink`, then an attacker can
 * control if `action` should be executed or not.
 */
predicate isTaintedGuardForSensitiveAction(Sink sink, DataFlow::Node source, SensitiveAction action) {
  action = sink.getAction() and
  // exclude the intermediary sink
  not sink instanceof SensitiveActionGuardComparisonOperand and
  exists (Configuration cfg  |
    // ordinary taint tracking to a guard
    cfg.hasFlow(source, sink) or
    // taint tracking to both operands of a guard comparison
    exists (SensitiveActionGuardComparison cmp, DataFlow::Node lSource, DataFlow::Node rSource |
      sink = cmp.getGuard() and
      cfg.hasFlow(lSource, DataFlow::valueNode(cmp.getLeftOperand())) and
      cfg.hasFlow(rSource, DataFlow::valueNode(cmp.getRightOperand())) |
      source = lSource or
      source = rSource
    )
  )
}

/**
 * Holds if `e` effectively guards access to `action` by returning or throwing early.
 *
 * Example: `if (e) return; action(x)`.
 */
predicate isEarlyAbortGuard(Sink e, SensitiveAction action) {
  exists (IfStmt guard |
    // `e` is in the condition of an if-statement ...
    e.asExpr().getParentExpr*() = guard.getCondition() and
    // ... where the then-branch always throws or returns
    exists (Stmt abort |
      abort instanceof ThrowStmt or
      abort instanceof ReturnStmt |
      abort.nestedIn(guard) and
      abort.getBasicBlock().(ReachableBasicBlock).postDominates(guard.getThen().getBasicBlock() )
    ) and
    // ... and the else-branch does not exist
    not exists (guard.getElse()) |
    // ... and `action` is outside the if-statement
    not action.asExpr().getEnclosingStmt().nestedIn(guard)
  )
}

from DataFlow::Node source, DataFlow::Node sink, SensitiveAction action
where isTaintedGuardForSensitiveAction(sink, source, action) and
      not isEarlyAbortGuard(sink, action)
select sink, "This condition guards a sensitive $@, but $@ controls it.",
    action, "action",
    source, "a user-provided value"
