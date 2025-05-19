/**
 * Provides classes and predicates for integer guards.
 */

import java
private import SSA
private import RangeUtils
private import RangeAnalysis

/** Gets an expression that might have the value `i`. */
private Expr exprWithIntValue(int i) {
  result.(ConstantIntegerExpr).getIntValue() = i or
  result.(ChooseExpr).getAResultExpr() = exprWithIntValue(i)
}

/**
 * An expression for which the predicate `integerGuard` is relevant.
 * This includes `VarRead` and `MethodCall`.
 */
class IntComparableExpr extends Expr {
  IntComparableExpr() { this instanceof VarRead or this instanceof MethodCall }

  /** Gets an integer that is directly assigned to the expression in case of a variable; or zero. */
  int relevantInt() {
    exists(SsaExplicitUpdate ssa, SsaSourceVariable v |
      this = v.getAnAccess() and
      ssa.getSourceVariable() = v and
      ssa.getDefiningExpr().(VariableAssign).getSource() = exprWithIntValue(result)
    )
    or
    result = 0
  }
}

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
 */
pragma[nomagic]
predicate rangeGuard(Expr guard, boolean branch, Expr e, int k, boolean upper) {
  exists(EqualityTest eqtest, Expr c |
    eqtest = guard and
    eqtest.hasOperands(e, c) and
    bounded(c, any(ZeroBound zb), k, upper, _) and
    branch = eqtest.polarity()
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
 * An expression that directly tests whether a given expression is equal to `k` or not.
 * The set of `k`s is restricted to those that are relevant for the expression or
 * have a direct comparison with the expression.
 *
 * If `result` evaluates to `branch`, then `e` is guaranteed to be equal to `k` if `is_k`
 * is true, and different from `k` if `is_k` is false.
 */
pragma[nomagic]
Expr integerGuard(IntComparableExpr e, boolean branch, int k, boolean is_k) {
  exists(EqualityTest eqtest, boolean polarity |
    eqtest = result and
    eqtest.hasOperands(e, any(ConstantIntegerExpr c | c.getIntValue() = k)) and
    polarity = eqtest.polarity() and
    (
      branch = true and is_k = polarity
      or
      branch = false and is_k = polarity.booleanNot()
    )
  )
  or
  exists(int val, boolean upper |
    rangeGuard(result, branch, e, val, upper) and
    k = e.relevantInt() and
    is_k = false
  |
    upper = true and val < k // e <= val < k  ==>  e != k
    or
    upper = false and val > k // e >= val > k  ==>  e != k
  )
}

/**
 * A guard that splits the values of a variable into one range with an upper bound of `k-1`
 * and one with a lower bound of `k`.
 *
 * If `branch_with_lower_bound_k` is true then `result` is equivalent to `k <= x`
 * and if it is false then `result` is equivalent to `k > x`.
 */
Expr intBoundGuard(VarRead x, boolean branch_with_lower_bound_k, int k) {
  exists(ComparisonExpr comp, ConstantIntegerExpr c, int val |
    comp = result and
    comp.hasOperands(x, c) and
    c.getIntValue() = val and
    x.getVariable().getType() instanceof IntegralType
  |
    // c < x
    comp.getLesserOperand() = c and
    comp.isStrict() and
    branch_with_lower_bound_k = true and
    val + 1 = k
    or
    // c <= x
    comp.getLesserOperand() = c and
    not comp.isStrict() and
    branch_with_lower_bound_k = true and
    val = k
    or
    // x < c
    comp.getGreaterOperand() = c and
    comp.isStrict() and
    branch_with_lower_bound_k = false and
    val = k
    or
    // x <= c
    comp.getGreaterOperand() = c and
    not comp.isStrict() and
    branch_with_lower_bound_k = false and
    val + 1 = k
  )
}
