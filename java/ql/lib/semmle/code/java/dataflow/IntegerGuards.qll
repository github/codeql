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
 * This includes `RValue` and `MethodAccess`.
 */
class IntComparableExpr extends Expr {
  IntComparableExpr() { this instanceof RValue or this instanceof MethodAccess }

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
  exists(EqualityTest eqtest, int val, Expr c, boolean upper |
    k = e.relevantInt() and
    eqtest = result and
    eqtest.hasOperands(e, c) and
    bounded(c, any(ZeroBound zb), val, upper, _) and
    is_k = false and
    (
      upper = true and val < k
      or
      upper = false and val > k
    ) and
    branch = eqtest.polarity()
  )
  or
  exists(ComparisonExpr comp, Expr c, int val, boolean upper |
    k = e.relevantInt() and
    comp = result and
    comp.hasOperands(e, c) and
    bounded(c, any(ZeroBound zb), val, upper, _) and
    is_k = false
  |
    // k <= val <= c < e, so e != k
    comp.getLesserOperand() = c and
    comp.isStrict() and
    branch = true and
    val >= k and
    upper = false
    or
    comp.getLesserOperand() = c and
    comp.isStrict() and
    branch = false and
    val < k and
    upper = true
    or
    comp.getLesserOperand() = c and
    not comp.isStrict() and
    branch = true and
    val > k and
    upper = false
    or
    comp.getLesserOperand() = c and
    not comp.isStrict() and
    branch = false and
    val <= k and
    upper = true
    or
    comp.getGreaterOperand() = c and
    comp.isStrict() and
    branch = true and
    val <= k and
    upper = true
    or
    comp.getGreaterOperand() = c and
    comp.isStrict() and
    branch = false and
    val > k and
    upper = false
    or
    comp.getGreaterOperand() = c and
    not comp.isStrict() and
    branch = true and
    val < k and
    upper = true
    or
    comp.getGreaterOperand() = c and
    not comp.isStrict() and
    branch = false and
    val >= k and
    upper = false
  )
}

/**
 * A guard that splits the values of a variable into one range with an upper bound of `k-1`
 * and one with a lower bound of `k`.
 *
 * If `branch_with_lower_bound_k` is true then `result` is equivalent to `k <= x`
 * and if it is false then `result` is equivalent to `k > x`.
 */
Expr intBoundGuard(RValue x, boolean branch_with_lower_bound_k, int k) {
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
