/**
 * @name Lossy pointer cast
 * @description A pointer type is converted to a smaller integer type. This may
 *              lead to loss of information in the variable and is highly
 *              non-portable.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cpp/lossy-pointer-cast
 * @tags reliability
 *       correctness
 *       types
 */

import cpp

predicate lossyPointerCast(Expr e, PointerType pt, IntegralType it) {
  not it instanceof BoolType and
  e.getConversion().getType().getUnderlyingType() = it and
  e.getType().getUnderlyingType() = pt and
  it.getSize() < pt.getSize() and
  not e.isInMacroExpansion() and
  // low bits of pointers are sometimes used to store flags
  not exists(BitwiseAndExpr a | a.getAnOperand() = e)
}

from Expr e, PointerType pt, IntegralType it
where lossyPointerCast(e, pt, it)
select e, "Converted from " + pt.getName() + " to smaller type " + it.getName()
