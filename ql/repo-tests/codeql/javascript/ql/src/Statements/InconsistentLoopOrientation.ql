/**
 * @name Inconsistent direction of for loop
 * @description A 'for' loop that increments its loop variable but checks it
 *              against a lower bound, or decrements its loop variable but
 *              checks it against an upper bound, will either stop iterating
 *              immediately or keep iterating indefinitely, and is usually
 *              indicative of a typo.
 * @kind problem
 * @problem.severity error
 * @id js/inconsistent-loop-direction
 * @tags correctness
 *       external/cwe/cwe-835
 * @precision very-high
 */

import javascript

/**
 * Holds if `test` bounds `v` in `direction`, which is either `"upward"`
 * or `"downward"`.
 *
 * For example, `x < 42` bounds `x` upward, while `y >= 0` bounds `y`
 * downward.
 */
predicate bounds(RelationalComparison test, Variable v, string direction) {
  test.getLesserOperand() = v.getAnAccess() and direction = "upward"
  or
  test.getGreaterOperand() = v.getAnAccess() and direction = "downward"
}

/**
 * Holds if `upd` updates `v` in `direction`, which is either `"upward"`
 * or `"downward"`.
 *
 * For example, `++x` updates `x` upward, while `y--` updates `y`
 * downward.
 */
predicate updates(UpdateExpr upd, Variable v, string direction) {
  upd.getOperand() = v.getAnAccess() and
  (
    upd instanceof IncExpr and direction = "upward"
    or
    upd instanceof DecExpr and direction = "downward"
  )
}

from ForStmt l, Variable v, string d1, string d2
where
  bounds(l.getTest(), v, d1) and
  updates(l.getUpdate(), v, d2) and
  d1 != d2
select l, "This loop counts " + d2 + ", but its variable is bounded " + d1 + "."
