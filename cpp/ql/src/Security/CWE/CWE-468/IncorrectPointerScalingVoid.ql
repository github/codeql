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
import cpp
import semmle.code.cpp.controlflow.SSA
import IncorrectPointerScalingCommon

private Type baseType(Type t) {
  exists (DerivedType dt
  | dt = t.getUnspecifiedType() and
    isPointerType(dt) and
    result = dt.getBaseType().getUnspecifiedType())

  // Make sure that the type has a size and that it isn't ambiguous.
  and strictcount(result.getSize()) = 1
}

from Expr dest, Type destType, Type sourceType, Type sourceBase,
     Type destBase, Location sourceLoc
where exists(pointerArithmeticParent(dest))
  and exprSourceType(dest, sourceType, sourceLoc)
  and sourceBase = baseType(sourceType)
  and destType = dest.getFullyConverted().getType()
  and destBase = baseType(destType)
  and destBase.getSize() != sourceBase.getSize()
  and not dest.isInMacroExpansion()

  // Only produce alerts that are not produced by `IncorrectPointerScaling.ql`.
  and (destBase instanceof VoidType)
select
  dest,
  "This pointer might have type $@ (size " + sourceBase.getSize() +
  "), but the pointer arithmetic here is done with type void",
  sourceLoc, sourceBase.toString()
