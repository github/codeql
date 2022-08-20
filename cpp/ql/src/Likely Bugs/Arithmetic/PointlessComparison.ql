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

// Trivial comparisons of the form 1 > 0 are usually due to macro expansion.
// For example:
//
// #define PRINTMSG(val,msg) { if (val >= PRINTLEVEL) printf(msg); }
//
// So to reduce the number of false positives, we do not report a result if
// the comparison is in a macro expansion. Similarly for template
// instantiations.
from ComparisonOperation cmp, SmallSide ss, float left, float right, boolean value, string reason
where
  not cmp.isInMacroExpansion() and
  not cmp.isFromTemplateInstantiation(_) and
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
    // If either of the operands is constant, then don't include it.
    (
      if cmp.getLeftOperand().isConstant()
      then not cmp.getRightOperand().isConstant() and reason = rightReason
      else
        if cmp.getRightOperand().isConstant()
        then reason = leftReason
        else reason = leftReason + " and " + rightReason
    )
  ) and
  // Don't report results which have already been reported by UnsignedGEZero.
  not unsignedGEZero(cmp, _)
select cmp, "Comparison is always " + value.toString() + " because " + reason + "."
