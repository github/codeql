/**
 * @name Equality test on floating-point values
 * @description Comparing results of floating-point computations with '==' or
 *              '!=' is likely to yield surprising results since floating-point
 *              computation does not follow the standard rules of algebra.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cpp/equality-on-floats
 * @tags reliability
 *       correctness
 */

import cpp
import semmle.code.cpp.ConfigurationTestFile

from EqualityOperation ro, Expr left, Expr right
where
  left = ro.getLeftOperand() and
  right = ro.getRightOperand() and
  ro.getAnOperand().getExplicitlyConverted().getType().getUnderlyingType() instanceof
    FloatingPointType and
  not ro.getAnOperand().isConstant() and // comparisons to constants generate too many false positives
  not left.(VariableAccess).getTarget() = right.(VariableAccess).getTarget() and // skip self comparison
  not ro.getFile() instanceof ConfigurationTestFile // expressions in files generated during configuration are likely false positives
select ro, "Equality checks on floating point values can yield unexpected results."
