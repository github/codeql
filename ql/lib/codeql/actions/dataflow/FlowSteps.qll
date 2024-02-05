/**
 * Provides classes representing various flow steps for taint tracking.
 */

import actions
private import codeql.util.Unit
private import codeql.actions.DataFlow

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to all
 * taint configurations.
 */
class AdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for all configurations.
   */
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

private class ActionsFindAndReplaceStringStep extends AdditionalTaintStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    exists(UsesExpr u |
      u.getTarget() = "mad9000/actions-find-and-replace-string" and
      pred.asExpr() = u.getArgument(["source", "replace"]) and
      succ.asExpr() = u
    )
  }
}
