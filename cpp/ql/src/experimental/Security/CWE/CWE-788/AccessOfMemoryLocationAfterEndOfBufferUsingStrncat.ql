/**
 * @name Access Of Memory Location After The End Of A Buffer Using Strncat
 * @description Calls of the form `strncat(dest, source, sizeof (dest) - strlen (dest))` set the third argument to one more than possible. So when `dest` is full, the expression `sizeof(dest) - strlen (dest)` will be equal to one, and not zero as the programmer might think. Making a call of this type may result in a zero byte being written just outside the `dest` buffer.
 * @kind problem
 * @id cpp/access-memory-location-after-end-buffer
 * @problem.severity warning
 * @precision medium
 * @tags correctness
 *       security
 *       external/cwe/cwe-788
 */

import cpp
import semmle.code.cpp.valuenumbering.GlobalValueNumbering

/**
 * A call to `strncat` of the form `strncat(buff, str, someExpr - strlen(buf))`, for some expression `someExpr` equal to `sizeof(buff)`.
 */
class WrongCallStrncat extends FunctionCall {
  Expr leftsomeExpr;

  WrongCallStrncat() {
    this.getTarget().hasGlobalOrStdName("strncat") and
    // the expression of the first argument in `strncat` and `strnlen` is identical
    globalValueNumber(this.getArgument(0)) =
      globalValueNumber(this.getArgument(2).(SubExpr).getRightOperand().(StrlenCall).getStringExpr()) and
    // using a string constant often speaks of manually calculating the length of the required buffer.
    (
      not this.getArgument(1) instanceof StringLiteral and
      not this.getArgument(1) instanceof CharLiteral
    ) and
    // for use in predicates
    leftsomeExpr = this.getArgument(2).(SubExpr).getLeftOperand()
  }

  /**
   * Holds if the left side of the expression `someExpr` equal to `sizeof(buf)`.
   */
  predicate isExpressionEqualSizeof() {
    // the left side of the expression `someExpr` is `sizeof(buf)`.
    globalValueNumber(this.getArgument(0)) =
      globalValueNumber(leftsomeExpr.(SizeofExprOperator).getExprOperand())
    or
    // value of the left side of the expression `someExpr` equal  `sizeof(buf)` value, and `buf` is array.
    leftsomeExpr.getValue().toInt() = this.getArgument(0).getType().getSize()
  }

  /**
   * Holds if the left side of the expression `someExpr` equal to variable containing the length of the memory allocated for the buffer.
   */
  predicate isVariableEqualValueSizegBuffer() {
    // the left side of expression `someExpr` is the variable that was used in the function of allocating memory for the buffer`.
    exists(AllocationExpr alc |
      leftsomeExpr.(VariableAccess).getTarget() =
        alc.(FunctionCall).getArgument(0).(VariableAccess).getTarget()
    )
  }
}

from WrongCallStrncat sc
where
  sc.isExpressionEqualSizeof() or
  sc.isVariableEqualValueSizegBuffer()
select sc, "if the used buffer is full, writing out of the buffer is possible"
