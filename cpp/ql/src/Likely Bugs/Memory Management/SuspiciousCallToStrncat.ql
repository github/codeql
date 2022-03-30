/**
 * @name Potentially unsafe call to strncat
 * @description Calling 'strncat' with an incorrect size argument may result in a buffer overflow.
 * @kind problem
 * @problem.severity warning
 * @security-severity 9.3
 * @precision medium
 * @id cpp/unsafe-strncat
 * @tags reliability
 *       correctness
 *       security
 *       external/cwe/cwe-788
 *       external/cwe/cwe-676
 *       external/cwe/cwe-119
 *       external/cwe/cwe-251
 */

import cpp
import Buffer
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

/**
 * Holds if `fc` is a call to `strncat` with size argument `sizeArg` and destination
 * argument `destArg`, and `destArg` is the size of the buffer pointed to by `destArg`.
 */
predicate case1(FunctionCall fc, Expr sizeArg, VariableAccess destArg) {
  interestringCallWithArgs(fc, sizeArg, destArg) and
  exists(VariableAccess va |
    va = sizeArg.(BufferSizeExpr).getArg() and
    destArg.getTarget() = va.getTarget()
  )
}

/**
 * Holds if `fc` is a call to `strncat` with size argument `sizeArg` and destination
 * argument `destArg`, and `sizeArg` computes the value `sizeof (dest) - strlen (dest)`.
 */
predicate case2(FunctionCall fc, Expr sizeArg, VariableAccess destArg) {
  interestringCallWithArgs(fc, sizeArg, destArg) and
  exists(SubExpr sub, int n |
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
  )
}

from FunctionCall fc, Expr sizeArg, Expr destArg
where case1(fc, sizeArg, destArg) or case2(fc, sizeArg, destArg)
select fc, "Potentially unsafe call to strncat."
