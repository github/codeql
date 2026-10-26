/**
 * Provides a taint tracking configuration for reasoning about bypass of sensitive action guards.
 *
 * Note, for performance reasons: only import this file if
 * `ConditionalBypass::Configuration` is needed, otherwise
 * `ConditionalBypassCustomizations` should be imported instead.
 */

import javascript
private import semmle.javascript.security.SensitiveActions
import ConditionalBypassCustomizations::ConditionalBypass

/**
 * A taint tracking configuration for bypass of sensitive action guards.
 */
module ConditionalBypassConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    // comparing a tainted expression against a constant gives a tainted result
    node2.asExpr().(Comparison).hasOperands(node1.asExpr(), any(ConstantExpr c))
  }

  predicate observeDiffInformedIncrementalMode() {
    none() // Disabled since the enclosing comparison is sometimes selected instead of the sink
  }
}

/**
 * Taint tracking flow for bypass of sensitive action guards.
 */
module ConditionalBypassFlow = TaintTracking::Global<ConditionalBypassConfig>;

/**
 * DEPRECATED. Use the `ConditionalBypassFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "ConditionalBypass" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node src, DataFlow::Node dst) {
    ConditionalBypassConfig::isAdditionalFlowStep(src, dst)
  }
}

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

  SensitiveActionGuardComparison() { flowsToGuardExpr(DataFlow::valueNode(this), guard) }

  /**
   * Gets the guard that uses this comparison.
   */
  SensitiveActionGuardConditional getGuard() { result = guard }
}

/**
 * An intermediary sink to enable reuse of the taint configuration.
 * This sink should not be presented to the client of this query.
 */
class SensitiveActionGuardComparisonOperand extends Sink {
  SensitiveActionGuardComparison comparison;

  SensitiveActionGuardComparisonOperand() { this.asExpr() = comparison.getAnOperand() }

  override SensitiveAction getAction() { result = comparison.getGuard().getAction() }
}

/**
 * Holds if `sink` guards `action`, and `source` taints `sink`.
 *
 * If flow from `source` taints `sink`, then an attacker can
 * control if `action` should be executed or not.
 */
predicate isTaintedGuardNodeForSensitiveAction(
  ConditionalBypassFlow::PathNode sink, ConditionalBypassFlow::PathNode source,
  SensitiveAction action
) {
  action = sink.getNode().(Sink).getAction() and
  // exclude the intermediary sink
  not sink.getNode() instanceof SensitiveActionGuardComparisonOperand and
  (
    // ordinary taint tracking to a guard
    ConditionalBypassFlow::flowPath(source, sink)
    or
    // taint tracking to both operands of a guard comparison
    exists(
      SensitiveActionGuardComparison cmp, ConditionalBypassFlow::PathNode lSource,
      ConditionalBypassFlow::PathNode rSource, ConditionalBypassFlow::PathNode lSink,
      ConditionalBypassFlow::PathNode rSink
    |
      sink.getNode() = cmp.getGuard() and
      ConditionalBypassFlow::flowPath(lSource, lSink) and
      lSink.getNode() = DataFlow::valueNode(cmp.getLeftOperand()) and
      ConditionalBypassFlow::flowPath(rSource, rSink) and
      rSink.getNode() = DataFlow::valueNode(cmp.getRightOperand())
    |
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
predicate isEarlyAbortGuardNode(ConditionalBypassFlow::PathNode e, SensitiveAction action) {
  exists(IfStmt guard |
    // `e` is in the condition of an if-statement ...
    e.getNode().(Sink).asExpr().getParentExpr*() = guard.getCondition() and
    // ... where the then-branch always throws or returns
    exists(Stmt abort |
      abort instanceof ThrowStmt or
      abort instanceof ReturnStmt
    |
      abort.nestedIn(guard) and
      abort.getBasicBlock().(ReachableBasicBlock).postDominates(guard.getThen().getBasicBlock())
    ) and
    // ... and the else-branch does not exist
    not exists(guard.getElse())
  |
    // ... and `action` is outside the if-statement
    not action.asExpr().getEnclosingStmt().nestedIn(guard)
  )
}

/**
 * Holds if `sink` guards `action`, and `source` taints `sink`.
 *
 * If flow from `source` taints `sink`, then an attacker can
 * control if `action` should be executed or not.
 */
deprecated predicate isTaintedGuardForSensitiveAction(
  DataFlow::PathNode sink, DataFlow::PathNode source, SensitiveAction action
) {
  action = sink.getNode().(Sink).getAction() and
  // exclude the intermediary sink
  not sink.getNode() instanceof SensitiveActionGuardComparisonOperand and
  exists(Configuration cfg |
    // ordinary taint tracking to a guard
    cfg.hasFlowPath(source, sink)
    or
    // taint tracking to both operands of a guard comparison
    exists(
      SensitiveActionGuardComparison cmp, DataFlow::PathNode lSource, DataFlow::PathNode rSource,
      DataFlow::PathNode lSink, DataFlow::PathNode rSink
    |
      sink.getNode() = cmp.getGuard() and
      cfg.hasFlowPath(lSource, lSink) and
      lSink.getNode() = DataFlow::valueNode(cmp.getLeftOperand()) and
      cfg.hasFlowPath(rSource, rSink) and
      rSink.getNode() = DataFlow::valueNode(cmp.getRightOperand())
    |
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
deprecated predicate isEarlyAbortGuard(DataFlow::PathNode e, SensitiveAction action) {
  exists(IfStmt guard |
    // `e` is in the condition of an if-statement ...
    e.getNode().(Sink).asExpr().getParentExpr*() = guard.getCondition() and
    // ... where the then-branch always throws or returns
    exists(Stmt abort |
      abort instanceof ThrowStmt or
      abort instanceof ReturnStmt
    |
      abort.nestedIn(guard) and
      abort.getBasicBlock().(ReachableBasicBlock).postDominates(guard.getThen().getBasicBlock())
    ) and
    // ... and the else-branch does not exist
    not exists(guard.getElse())
  |
    // ... and `action` is outside the if-statement
    not action.asExpr().getEnclosingStmt().nestedIn(guard)
  )
}
