/**
 * @name Suspicious add with sizeof
 * @description Explicitly scaled pointer arithmetic expressions
 *              can cause buffer overflow conditions if the offset is also
 *              implicitly scaled.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cpp/suspicious-add-sizeof
 * @tags security
 *       external/cwe/cwe-468
 */
import cpp
import IncorrectPointerScalingCommon

private predicate isCharPtrExpr(Expr e) {
  exists (PointerType pt
  | pt = e.getFullyConverted().getUnderlyingType()
  | pt.getBaseType().getUnspecifiedType() instanceof CharType)
}

from Expr sizeofExpr, Expr e
where
  // If we see an addWithSizeof then we expect the type of
  // the pointer expression to be char*. Otherwise it is probably
  // a mistake.
  addWithSizeof(e, sizeofExpr, _) and not isCharPtrExpr(e)
select
  sizeofExpr,
  "Suspicious sizeof offset in a pointer arithmetic expression. " +
  "The type of the pointer is " +
  e.getFullyConverted().getType().toString() + "."
