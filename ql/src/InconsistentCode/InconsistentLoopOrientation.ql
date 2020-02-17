/**
 * @name Inconsistent direction of for loop
 * @description A 'for' loop that increments its loop variable but checks it
 *              against a lower bound, or decrements its loop variable but
 *              checks it against an upper bound, will either stop iterating
 *              immediately or keep iterating indefinitely, and is usually
 *              indicative of a typo.
 * @kind problem
 * @problem.severity error
 * @id go/inconsistent-loop-direction
 * @tags correctness
 *       external/cwe/cwe-835
 * @precision very-high
 */

import go

/**
 * Holds if `test` bounds `v` in `direction`, which is either `"upward"`
 * or `"downward"`.
 *
 * For example, `x < 42` bounds `x` upward, while `y >= 0` bounds `y`
 * downward.
 */
predicate bounds(RelationalComparisonExpr test, Variable v, string direction) {
  test.getLesserOperand() = v.getAReference() and direction = "upward"
  or
  test.getGreaterOperand() = v.getAReference() and direction = "downward"
}

/**
 * Holds if `upd` updates `v` in `direction`, which is either `"upward"`
 * or `"downward"`.
 *
 * For example, `++x` updates `x` upward, while `y--` updates `y`
 * downward.
 */
predicate updates(IncDecStmt upd, Variable v, string direction) {
  upd.getOperand() = v.getAReference() and
  (
    upd instanceof IncStmt and direction = "upward"
    or
    upd instanceof DecStmt and direction = "downward"
  )
}

from ForStmt l, Variable v, string d1, string d2
where
  bounds(l.getCond(), v, d1) and
  updates(l.getPost(), v, d2) and
  d1 != d2 and
  // `for u = n; u <= n; u--` is a somewhat common idiom
  not (v.getType().getUnderlyingType() instanceof UnsignedIntegerType and d2 = "downward")
select l.getPost(), "This loop counts " + d2 + ", but its variable is $@ " + d1 + ".", l.getCond(),
  "bounded"
