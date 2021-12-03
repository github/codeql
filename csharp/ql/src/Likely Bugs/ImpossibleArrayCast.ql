/**
 * @name Impossible array cast
 * @description Downcasts on expressions of array type are sometimes guaranteed to fail at runtime, e.g. those applied to array creation expressions.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/impossible-array-cast
 * @tags reliability
 *       correctness
 *       logic
 */

import csharp

from CastExpr ce, RefType target, RefType source
where
  ce.getExpr() instanceof ArrayCreation and
  target = ce.getType().(ArrayType).getElementType() and
  source = ce.getExpr().getType().(ArrayType).getElementType() and
  target.getABaseType+() = source
select ce, "Impossible downcast on array."
