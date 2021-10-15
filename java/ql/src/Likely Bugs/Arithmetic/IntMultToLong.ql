/**
 * @name Result of multiplication cast to wider type
 * @description Casting the result of a multiplication to a wider type instead of casting
 *              before the multiplication may cause overflow.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id java/integer-multiplication-cast-to-long
 * @tags reliability
 *       correctness
 *       types
 *       external/cwe/cwe-190
 *       external/cwe/cwe-192
 *       external/cwe/cwe-197
 *       external/cwe/cwe-681
 */

import java
import semmle.code.java.dataflow.RangeUtils
import semmle.code.java.dataflow.RangeAnalysis
import semmle.code.java.Conversions

/** Gets an upper bound on the absolute value of `e`. */
float exprBound(Expr e) {
  result = e.(ConstantIntegerExpr).getIntValue().(float).abs()
  or
  exists(float lower, float upper |
    bounded(e, any(ZeroBound zb), lower, false, _) and
    bounded(e, any(ZeroBound zb), upper, true, _) and
    result = upper.abs().maximum(lower.abs())
  )
}

/** A multiplication that does not overflow. */
predicate small(MulExpr e) {
  exists(NumType t, float lhs, float rhs, float res | t = e.getType() |
    lhs = exprBound(e.getLeftOperand()) and
    rhs = exprBound(e.getRightOperand()) and
    lhs * rhs = res and
    res <= t.getOrdPrimitiveType().getMaxValue()
  )
}

/**
 * A parent of e, but only one that roughly preserves the value - in particular, not calls.
 */
Expr getRestrictedParent(Expr e) {
  result = e.getParent() and
  (result instanceof ArithExpr or result instanceof ConditionalExpr)
}

from ConversionSite c, MulExpr e, NumType sourceType, NumType destType
where
  // e is nested inside c, with only parents that roughly "preserve" the value
  getRestrictedParent*(e) = c and
  // the destination type is wider than the type of the multiplication
  e.getType() = sourceType and
  c.getConversionTarget() = destType and
  destType.widerThan(sourceType) and
  // restrict attention to integral types
  destType instanceof IntegralType and
  // not a trivial conversion
  not c.isTrivial() and
  // not an explicit conversion, which is probably intended by a user
  c.isImplicit() and
  // not obviously small and ok
  not small(e) and
  e.getEnclosingCallable().fromSource()
select c,
  "Potential overflow in $@ before it is converted to " + destType.getName() + " by use in " +
    ("a " + c.kind()).regexpReplaceAll("^a ([aeiou])", "an $1") + ".", e,
  sourceType.getName() + " multiplication"
