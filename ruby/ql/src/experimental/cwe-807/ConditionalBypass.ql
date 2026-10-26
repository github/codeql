/**
 * @name User-controlled bypass of security check
 * @description Conditions controlled by the user are not suited for making security-related decisions.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision medium
 * @id rb/user-controlled-bypass
 * @tags security
 *       experimental
 *       external/cwe/cwe-807
 *       external/cwe/cwe-290
 */

import codeql.ruby.AST
import codeql.ruby.DataFlow
import codeql.ruby.dataflow.internal.DataFlowPublic
import codeql.ruby.security.ConditionalBypassQuery
import codeql.ruby.security.SensitiveActions
import ConditionalBypassFlow::PathGraph

/**
 * Holds if the value of `nd` flows into `guard`.
 */
predicate flowsToGuardExpr(DataFlow::Node nd, SensitiveActionGuardConditional guard) {
  nd = guard
  or
  exists(DataFlow::Node succ | localFlowStep(nd, succ) | flowsToGuardExpr(succ, guard))
}

/**
 * A comparison that guards a sensitive action, e.g. the comparison in:
 * ```rb
 * ok = x == y
 * if ok
 *   login
 * end
 * ```
 */
class SensitiveActionGuardComparison extends ComparisonOperation {
  SensitiveActionGuardConditional guard;

  SensitiveActionGuardComparison() {
    exists(DataFlow::Node node | this = node.asExpr().getExpr() | flowsToGuardExpr(node, guard))
  }

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

  SensitiveActionGuardComparisonOperand() { this.asExpr().getExpr() = comparison.getAnOperand() }

  override SensitiveAction getAction() { result = comparison.getGuard().getAction() }
}

/**
 * Holds if `sink` guards `action`, and `source` taints `sink`.
 *
 * If flow from `source` taints `sink`, then an attacker can
 * control if `action` should be executed or not.
 */
predicate isTaintedGuardForSensitiveAction(
  ConditionalBypassFlow::PathNode sink, ConditionalBypassFlow::PathNode source,
  SensitiveAction action
) {
  action = sink.getNode().(Sink).getAction() and
  // exclude the intermediary sink
  not sink.getNode() instanceof SensitiveActionGuardComparisonOperand and
  ConditionalBypassFlow::flowPath(source, sink)
}

from
  ConditionalBypassFlow::PathNode source, ConditionalBypassFlow::PathNode sink,
  SensitiveAction action
where isTaintedGuardForSensitiveAction(sink, source, action)
select sink.getNode(), source, sink, "This condition guards a sensitive $@, but a $@ controls it.",
  action, "action", source.getNode(), "user-provided value"
