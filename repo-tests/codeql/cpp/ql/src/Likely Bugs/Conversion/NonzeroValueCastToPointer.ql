/**
 * @name Non-zero value cast to pointer
 * @description A constant value other than zero is converted to a pointer type. This is a dangerous practice, since the meaning of the numerical value of pointers is platform dependent.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id cpp/cast-to-pointer
 * @tags reliability
 *       correctness
 *       types
 */

import cpp

predicate commonErrorCode(string value) {
  value = "0" or
  value = "1" or
  value = "-1" or
  value = "18446744073709551615" or // 2^64-1, i.e. -1 as an unsigned int64
  value = "4294967295" or // 2^32-1, i.e. -1 as an unsigned int32
  value = "3735928559" or // 0xdeadbeef
  value = "3735929054" or // 0xdeadc0de
  value = "3405691582" // 0xcafebabe
}

from Expr e
where
  e.isConstant() and
  not commonErrorCode(e.getValue()) and
  e.getFullyConverted().getType() instanceof PointerType and
  not e.getType() instanceof ArrayType and
  not e.getType() instanceof PointerType and
  not e.isInMacroExpansion()
select e, "Nonzero value " + e.getValueText() + " cast to pointer."
