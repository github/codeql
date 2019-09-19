/**
 * @name Suspicious pointer scaling to void
 * @description Implicit scaling of pointer arithmetic expressions
 *              can cause buffer overflow conditions.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/suspicious-pointer-scaling-void
 * @tags security
 *       external/cwe/cwe-468
 */

import IncorrectPointerScalingCommon

from Expr dest, Type destType, Type sourceType, Type sourceBase, Type destBase, Location sourceLoc
where
  exists(pointerArithmeticParent(dest)) and
  exprSourceType(dest, sourceType, sourceLoc) and
  sourceBase = baseType(sourceType) and
  destType = dest.getFullyConverted().getType() and
  destBase = baseType(destType) and
  destBase.getSize() != sourceBase.getSize() and
  not dest.isInMacroExpansion() and
  // Only produce alerts that are not produced by `IncorrectPointerScaling.ql`.
  destBase instanceof VoidType
select dest,
  "This pointer might have type $@ (size " + sourceBase.getSize() +
    "), but the pointer arithmetic here is done with type void", sourceLoc, sourceBase.toString()
