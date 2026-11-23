/**
 * @name Comparison result is always the same
 * @description When a comparison operation, such as x < y, always
 *              returns the same result, it means that the comparison
 *              is redundant and may mask a bug because a different
 *              check was intended.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cpp/constant-comparison
 * @tags maintainability
 *       readability
 */

import cpp
private import semmle.code.cpp.commons.Exclusions
private import semmle.code.cpp.rangeanalysis.PointlessComparison
private import semmle.code.cpp.rangeanalysis.RangeAnalysisUtils
import UnsignedGEZero

/** Explains a value-changing integral conversion of a constant operand. */
bindingset[side]
private string constantConversionReason(Expr operand, string side) {
  if
    operand.getUnconverted().getValue() !=
      operand.getFullyConverted().(IntegralConversion).getValue()
  then
    result =
      " and the " + side + " operand evaluates to " + operand.getFullyConverted().getValue() +
        " after conversion"
  else result = ""
}

// Trivial comparisons of the form 1 > 0 are usually due to macro expansion.
// For example:
//
// #define PRINTMSG(val,msg) { if (val >= PRINTLEVEL) printf(msg); }
//
// So to reduce the number of false positives, we do not report a result if
// the comparison is in a macro expansion. Similarly for template
// instantiations, static asserts, non-type template arguments, enum constants,
// and constexprs.
from ComparisonOperation cmp, SmallSide ss, float left, float right, boolean value, string reason
where
  not cmp.isInMacroExpansion() and
  not cmp.isFromTemplateInstantiation(_) and
  not exists(StaticAssert s | s.getCondition() = cmp.getParent*()) and
  not exists(Declaration d | d.getATemplateArgument() = cmp.getParent*()) and
  not exists(Variable v | v.isConstexpr() | v.getInitializer().getExpr() = cmp.getParent*()) and
  not exists(EnumConstant e | e.getInitializer().getExpr() = cmp.getParent*()) and
  not functionContainsDisabledCode(cmp.getEnclosingFunction()) and
  reachablePointlessComparison(cmp, left, right, value, ss) and
  // a comparison between an enum and zero is always valid because whether
  // the underlying type of an enum is signed is compiler-dependent
  not exists(Expr e, ConstantZero z |
    relOpWithSwap(cmp, e.getFullyConverted(), z, _, _) and
    e.getUnderlyingType() instanceof Enum
  ) and
  // Construct a reason for the message. Something like: x >= 5 and 3 >= y.
  exists(string cmpOp, string leftReason, string rightReason |
    (
      ss = LeftIsSmaller() and cmpOp = " <= "
      or
      ss = RightIsSmaller() and cmpOp = " >= "
    ) and
    leftReason = cmp.getLeftOperand().toString() + cmpOp + left.toString() and
    rightReason = right.toString() + cmpOp + cmp.getRightOperand().toString() and
    // For a constant operand, explain its value only when conversion changes it.
    (
      if cmp.getLeftOperand().isConstant()
      then
        not cmp.getRightOperand().isConstant() and
        reason = rightReason + constantConversionReason(cmp.getLeftOperand(), "left")
      else
        if cmp.getRightOperand().isConstant()
        then reason = leftReason + constantConversionReason(cmp.getRightOperand(), "right")
        else reason = leftReason + " and " + rightReason
    )
  ) and
  // Don't report results which have already been reported by UnsignedGEZero.
  not unsignedGEZero(cmp, _)
select cmp, "Comparison is always " + value.toString() + " because " + reason + "."
