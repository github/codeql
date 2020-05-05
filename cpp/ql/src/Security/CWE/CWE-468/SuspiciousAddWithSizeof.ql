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

private predicate isCharSzPtrExpr(Expr e) {
  exists(PointerType pt | pt = e.getFullyConverted().getUnspecifiedType() |
    pt.getBaseType() instanceof CharType or
    pt.getBaseType() instanceof VoidType
  )
}

from Expr sizeofExpr, Expr e
where
  // If we see an addWithSizeof then we expect the type of
  // the pointer expression to be `char*` or `void*`. Otherwise it
  // is probably a mistake.
  addWithSizeof(e, sizeofExpr, _) and not isCharSzPtrExpr(e)
select sizeofExpr,
  "Suspicious sizeof offset in a pointer arithmetic expression. The type of the pointer is $@.",
  e.getFullyConverted().getType() as t, t.toString()
