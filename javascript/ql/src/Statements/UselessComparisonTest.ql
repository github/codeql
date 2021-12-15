/**
 * @name Useless comparison test
 * @description A comparison that always evaluates to true or always evaluates to false may
 *              indicate faulty logic and dead code.
 * @kind problem
 * @problem.severity warning
 * @id js/useless-comparison-test
 * @tags correctness
 * @precision high
 */

import javascript

/**
 * Holds if there are any contradictory guard nodes in `container`.
 *
 * We use this to restrict reachability analysis to a small set of containers.
 */
predicate hasContradictoryGuardNodes(StmtContainer container) {
  exists(ConditionGuardNode guard |
    RangeAnalysis::isContradictoryGuardNode(guard) and
    container = guard.getContainer()
  )
}

/**
 * Holds if `block` is reachable and is in a container with contradictory guard nodes.
 */
predicate isReachable(BasicBlock block) {
  exists(StmtContainer container |
    hasContradictoryGuardNodes(container) and
    block = container.getEntryBB()
  )
  or
  isReachable(block.getAPredecessor()) and
  not RangeAnalysis::isContradictoryGuardNode(block.getANode())
}

/**
 * Holds if `block` is unreachable, but could be reached if `guard` was not contradictory.
 */
predicate isBlockedByContradictoryGuardNodes(BasicBlock block, ConditionGuardNode guard) {
  RangeAnalysis::isContradictoryGuardNode(guard) and
  isReachable(block.getAPredecessor()) and // the guard itself is reachable
  block = guard.getBasicBlock()
  or
  isBlockedByContradictoryGuardNodes(block.getAPredecessor(), guard) and
  not isReachable(block)
}

/**
 * Holds if the given guard node is contradictory and causes an expression or statement to be unreachable.
 */
predicate isGuardNodeWithDeadCode(ConditionGuardNode guard) {
  exists(BasicBlock block |
    isBlockedByContradictoryGuardNodes(block, guard) and
    block.getANode() instanceof ExprOrStmt
  )
}

from ConditionGuardNode guard
where isGuardNodeWithDeadCode(guard)
select guard.getTest(),
  "The condition '" + guard.getTest() + "' is always " + guard.getOutcome().booleanNot() + "."
