/**
 * Provides classes and predicates for integer guards.
 */
overlay[local?]
module;

import java
private import SSA
private import RangeUtils
private import RangeAnalysis

/**
 * Holds if `comp` evaluating to `branch` ensures that `e1` is less than `e2`.
 * When `strict` is true, `e1` is strictly less than `e2`, otherwise it is less
 * than or equal to `e2`.
 */
private predicate comparison(ComparisonExpr comp, boolean branch, Expr e1, Expr e2, boolean strict) {
  branch = true and
  e1 = comp.getLesserOperand() and
  e2 = comp.getGreaterOperand() and
  (if comp.isStrict() then strict = true else strict = false)
  or
  branch = false and
  e1 = comp.getGreaterOperand() and
  e2 = comp.getLesserOperand() and
  (if comp.isStrict() then strict = false else strict = true)
}

/**
 * Holds if `guard` evaluating to `branch` ensures that:
 * `e <= k` when `upper = true`
 * `e >= k` when `upper = false`
 *
 * Does _not_ include the constant comparison case where the guard directly
 * ensures `e == k`.
 */
pragma[nomagic]
predicate rangeGuard(Expr guard, boolean branch, Expr e, int k, boolean upper) {
  exists(EqualityTest eqtest, Expr c |
    eqtest = guard and
    eqtest.hasOperands(e, c) and
    bounded(c, any(ZeroBound zb), k, upper, _) and
    branch = eqtest.polarity() and
    not c instanceof ConstantIntegerExpr
  )
  or
  exists(Expr c, int val, boolean strict, int d |
    bounded(c, any(ZeroBound zb), val, upper, _) and
    (
      upper = true and
      comparison(guard, branch, e, c, strict) and
      d = -1
      or
      upper = false and
      comparison(guard, branch, c, e, strict) and
      d = 1
    ) and
    (
      strict = false and k = val
      or
      // e < c <= val ==> e <= c - 1 <= val - 1
      // e > c >= val ==> e >= c + 1 >= val + 1
      strict = true and k = val + d
    )
  )
}

/**
 * Gets an expression that directly tests whether a given expression, `e`, is
 * non-zero.
 */
Expr nonZeroGuard(Expr e, boolean branch) {
  exists(EqualityTest eqtest, boolean polarity, int k |
    eqtest = result and
    eqtest.hasOperands(e, any(ConstantIntegerExpr c | c.getIntValue() = k)) and
    polarity = eqtest.polarity()
  |
    k = 0 and branch = polarity.booleanNot()
    or
    k != 0 and branch = polarity
  )
  or
  exists(int val, boolean upper | rangeGuard(result, branch, e, val, upper) |
    upper = true and val < 0 // e <= val < 0  ==>  e != 0
    or
    upper = false and val > 0 // e >= val > 0  ==>  e != 0
  )
}
