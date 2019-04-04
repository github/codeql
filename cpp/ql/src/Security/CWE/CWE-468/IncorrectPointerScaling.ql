/**
 * @name Suspicious pointer scaling
 * @description Implicit scaling of pointer arithmetic expressions
 *              can cause buffer overflow conditions.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cpp/suspicious-pointer-scaling
 * @tags security
 *       external/cwe/cwe-468
 */
import cpp
import semmle.code.cpp.controlflow.SSA
import IncorrectPointerScalingCommon

private Type baseType(Type t) {
  (
    exists (PointerType dt
    | dt = t.getUnspecifiedType() and
      result = dt.getBaseType().getUnspecifiedType()) or
    exists (ArrayType at
    | at = t.getUnspecifiedType() and
      (not at.getBaseType().getUnspecifiedType() instanceof ArrayType) and
      result = at.getBaseType().getUnspecifiedType()) or
    exists (ArrayType at, ArrayType at2
    | at = t.getUnspecifiedType() and
      at2 = at.getBaseType().getUnspecifiedType() and
      result = baseType(at2))
  )
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

  // If the source type is a char* or void* then don't
  // produce a result, because it is likely to be a false
  // positive.
  and not (sourceBase instanceof CharType)
  and not (sourceBase instanceof VoidType)

  // Low-level pointer tricks often involve casting a struct pointer to a
  // char pointer, then accessing it at byte offsets. For example, this can
  // be necessary in order to resume an interrupted `write(2)`.
  and not (destBase instanceof CharType)
  
  // Similarly, gcc and compilers emulating it will allow void pointer
  // arithmetic as if void were a 1-byte type
  and not (destBase instanceof VoidType)

  // Don't produce an alert if the root expression computes
  // an offset, rather than a pointer. For example:
  // ```
  //     (p + 1) - q
  // ```
  and forall(Expr parent |
             parent = pointerArithmeticParent+(dest) |
             parent.getFullyConverted().getType().getUnspecifiedType() instanceof PointerType)
select
  dest,
  "This pointer might have type $@ (size " + sourceBase.getSize() +
  "), but the pointer arithmetic here is done with type " +
  destType + " (size " + destBase.getSize() + ").",
  sourceLoc, sourceBase.toString()
