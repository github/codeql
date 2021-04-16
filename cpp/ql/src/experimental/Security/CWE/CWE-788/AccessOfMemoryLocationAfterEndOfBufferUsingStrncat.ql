/**
 * @name Access Of Memory Location After The End Of A Buffer Using Strncat
 * @description Calls of the form `strncat(dest, source, sizeof (dest) - strlen (dest))` set the third argument to one more than possible. So when `dest` is full, the expression `sizeof(dest) - strlen (dest)` will be equal to one, and not zero as the programmer might think. Making a call of this type may result in a zero byte being written just outside the `dest` buffer.
 * @kind problem
 * @id cpp/access-memory-location-after-end-buffer-strncat
 * @problem.severity warning
 * @precision medium
 * @tags correctness
 *       security
 *       external/cwe/cwe-788
 */

import cpp
import semmle.code.cpp.models.implementations.Strcat
import semmle.code.cpp.valuenumbering.GlobalValueNumbering

/**
 * Holds if `call` is a call to `strncat` such that `sizeArg` and `destArg` are the size and
 * destination arguments, respectively.
 */
predicate interestringCallWithArgs(Call call, Expr sizeArg, Expr destArg) {
  exists(StrcatFunction strcat |
    strcat = call.getTarget() and
    sizeArg = call.getArgument(strcat.getParamSize()) and
    destArg = call.getArgument(strcat.getParamDest())
  )
}

from FunctionCall call, Expr sizeArg, Expr destArg, SubExpr sub, int n
where
  interestringCallWithArgs(call, sizeArg, destArg) and
  // The destination buffer is an array of size n
  destArg.getUnspecifiedType().(ArrayType).getSize() = n and
  // The size argument is equivalent to a subtraction
  globalValueNumber(sizeArg).getAnExpr() = sub and
  // ... where the left side of the subtraction is the constant n
  globalValueNumber(sub.getLeftOperand()).getAnExpr().getValue().toInt() = n and
  // ... and the right side of the subtraction is a call to `strlen` where the argument is the
  // destination buffer.
  globalValueNumber(sub.getRightOperand()).getAnExpr().(StrlenCall).getStringExpr() =
    globalValueNumber(destArg).getAnExpr()
select call, "Possible out-of-bounds write due to incorrect size argument."
