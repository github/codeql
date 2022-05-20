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
  value =
    [
      "0", "1", "-1", // common error codes
      "18446744073709551615", // 2^64-1, i.e. -1 as an unsigned int64
      "4294967295", // 2^32-1, i.e. -1 as an unsigned int32
      "3735928559", // 0xdeadbeef
      "3735929054", // 0xdeadc0de
      "3405691582" // 0xcafebabe
    ]
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
