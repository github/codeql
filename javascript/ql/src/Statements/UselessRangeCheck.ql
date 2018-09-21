/**
 * @name Useless range check
 * @description If a range check always fails or always succeeds it is indicative of a bug.
 * @kind problem
 * @problem.severity warning
 * @id js/useless-range-check
 * @tags correctness
 * @precision high
 */

import javascript

/**
 * Gets the guard node with the opposite outcome of `guard`.
 */
ConditionGuardNode getOppositeGuard(ConditionGuardNode guard) {
  result.getTest() = guard.getTest() and
  result.getOutcome() = guard.getOutcome().booleanNot()
}

from ConditionGuardNode guard
where RangeAnalysis::isContradictoryGuardNode(guard)

  // Do not report conditions that themselves are unreachable because of
  // a prior contradiction.
  and not RangeAnalysis::isContradictoryGuardNode(getOppositeGuard(guard))

select guard.getTest(), "The condition '" + guard.getTest() + "' is always " + guard.getOutcome().booleanNot()
