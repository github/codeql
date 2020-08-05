/**
 * Provides utility predicates used by the pointless comparison queries.
 */

import cpp
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis

/** Gets the lower bound of the fully converted expression. */
private float lowerBoundFC(Expr expr) { result = lowerBound(expr.getFullyConverted()) }

/** Gets the upper bound of the fully converted expression. */
private float upperBoundFC(Expr expr) { result = upperBound(expr.getFullyConverted()) }

/**
 * Describes which side of a pointless comparison is known to be smaller.
 */
newtype SmallSide =
  /**
   * Represents that the left side of a pointless comparison is known to be smaller.
   */
  LeftIsSmaller() or
  /**
   * Represents that the right side of a pointless comparison is known to be smaller.
   */
  RightIsSmaller()

/**
 * Holds if `cmp` is a comparison operation in which the left hand
 * argument (which is at most `left`) is always strictly less than the
 * right hand argument (which is at least `right`), and `ss` is
 * `LeftIsSmaller`.
 *
 * Note that the comparison operation could be any binary comparison
 * operator, for example,`==`, `>`, or `<=`.
 */
private predicate alwaysLT(ComparisonOperation cmp, float left, float right, SmallSide ss) {
  ss = LeftIsSmaller() and
  left = upperBoundFC(cmp.getLeftOperand()) and
  right = lowerBoundFC(cmp.getRightOperand()) and
  left < right
}

/**
 * Holds if `cmp` is a comparison operation in which the left hand
 * argument (which is at most `left`) is always less than or equal to
 * the right hand argument (which is at least `right`), and `ss` is
 * `LeftIsSmaller`.
 *
 * Note that the comparison operation could be any binary comparison
 * operator, for example,`==`, `>`, or `<=`.
 */
private predicate alwaysLE(ComparisonOperation cmp, float left, float right, SmallSide ss) {
  ss = LeftIsSmaller() and
  left = upperBoundFC(cmp.getLeftOperand()) and
  right = lowerBoundFC(cmp.getRightOperand()) and
  left <= right and
  // Range analysis is not able to precisely represent large 64 bit numbers,
  // because it stores the range as a `float`, which only has a 53 bit mantissa.
  // For example, the number `2^64-1` is rounded to `2^64`. This means that we
  // cannot trust the result if the numbers are large. Note: there is only
  // a risk of a rounding error causing an incorrect result if `left == right`.
  // If `left` is strictly less than `right` then there is enough of a gap
  // that we don't need to worry about rounding errors.
  left.ulp() <= 1
}

/**
 * Holds if `cmp` is a comparison operation in which the left hand
 * argument (which is at least `left`) is always strictly greater than
 * the right hand argument (which is at most `right`), and `ss` is
 * `RightIsSmaller`.
 *
 * Note that the comparison operation could be any binary comparison
 * operator, for example,`==`, `>`, or `<=`.
 */
private predicate alwaysGT(ComparisonOperation cmp, float left, float right, SmallSide ss) {
  ss = RightIsSmaller() and
  left = lowerBoundFC(cmp.getLeftOperand()) and
  right = upperBoundFC(cmp.getRightOperand()) and
  left > right
}

/**
 * Holds if `cmp` is a comparison operation in which the left hand
 * argument (which is at least `left`) is always greater than or equal
 * to the right hand argument (which is at most `right`), and `ss` is
 * `RightIsSmaller`.
 *
 * Note that the comparison operation could be any binary comparison
 * operator, for example,`==`, `>`, or `<=`.
 */
private predicate alwaysGE(ComparisonOperation cmp, float left, float right, SmallSide ss) {
  ss = RightIsSmaller() and
  left = lowerBoundFC(cmp.getLeftOperand()) and
  right = upperBoundFC(cmp.getRightOperand()) and
  left >= right and
  // Range analysis is not able to precisely represent large 64 bit numbers,
  // because it stores the range as a `float`, which only has a 53 bit mantissa.
  // For example, the number 2^64-1 is rounded to 2^64. This means that we
  // cannot trust the result if the numbers are large. Note: there is only
  // a risk of a rounding error causing an incorrect result if `left == right`.
  // If `left` is strictly less than `right` then there is enough of a gap
  // that we don't need to worry about rounding errors.
  left.ulp() <= 1
}

/**
 * Holds if `cmp` is a comparison operation that always has the
 * result `value`, and either
 *  * `ss` is `LeftIsSmaller`, and the left hand argument is always at
 *    most `left`, the right hand argument at least `right`, and `left`
 *    is less than or equal to `right`; or
 *  * `ss` is `RightIsSmaller`, and the left hand argument is always at
 *    least `left`, the right hand argument at most `right`, and `left`
 *    is greater than or equal to `right`.
 *
 * For example, if the comparison `x < y` is always true because
 * `x <= 3` and `5 <= y` then
 * `pointlessComparison(x < y, 3, 5, true, LeftIsSmaller)` holds.
 *
 * Similarly, if the comparison `x < y` is always false because `x >= 9`
 * and `7 >= y` then
 * `pointlessComparison(x < y, 9, 7, false, RightIsSmaller)` holds.
 */
predicate pointlessComparison(
  ComparisonOperation cmp, float left, float right, boolean value, SmallSide ss
) {
  alwaysLT(cmp.(LTExpr), left, right, ss) and value = true
  or
  alwaysLE(cmp.(LEExpr), left, right, ss) and value = true
  or
  alwaysGT(cmp.(GTExpr), left, right, ss) and value = true
  or
  alwaysGE(cmp.(GEExpr), left, right, ss) and value = true
  or
  alwaysLT(cmp.(NEExpr), left, right, ss) and value = true
  or
  alwaysGT(cmp.(NEExpr), left, right, ss) and value = true
  or
  alwaysGE(cmp.(LTExpr), left, right, ss) and value = false
  or
  alwaysGT(cmp.(LEExpr), left, right, ss) and value = false
  or
  alwaysLE(cmp.(GTExpr), left, right, ss) and value = false
  or
  alwaysLT(cmp.(GEExpr), left, right, ss) and value = false
  or
  alwaysLT(cmp.(EQExpr), left, right, ss) and value = false
  or
  alwaysGT(cmp.(EQExpr), left, right, ss) and value = false
}

/**
 * Holds if `cmp` is a pointless comparison (see `pointlessComparison`
 * above) and `cmp` occurs in reachable code. The reason for excluding
 * expressions that occur in unreachable code is that range analysis
 * sometimes can deduce impossible ranges for them. For example:
 *
 *   if (10 < x) {
 *     if (x < 5) {
 *       // Unreachable code
 *       return x; // x has an empty range: 10 < x && x < 5
 *     }
 *   }
 */
predicate reachablePointlessComparison(
  ComparisonOperation cmp, float left, float right, boolean value, SmallSide ss
) {
  pointlessComparison(cmp, left, right, value, ss) and
  // Reachable according to control flow analysis.
  reachable(cmp) and
  // Reachable according to range analysis.
  not exprWithEmptyRange(cmp.getAChild+())
}
