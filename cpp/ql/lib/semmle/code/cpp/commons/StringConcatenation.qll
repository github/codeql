/**
 * A library for detecting general string concatenations.
 */

import cpp
import semmle.code.cpp.models.implementations.Strcat
import semmle.code.cpp.models.interfaces.FormattingFunction

class StringConcatenation extends Call {
  StringConcatenation() {
    // printf-like functions, i.e., concat through formating
    exists(FormattingFunctionCall fc | this = fc)
    or
    // strcat variants
    exists(StrcatFunction f | this.getTarget() = f)
    or
    // operator+ concat
    exists(Call call, Operator op |
      call.getTarget() = op and
      op.hasQualifiedName(["std", "bsl"], "operator+") and
      op.getType().(UserType).hasQualifiedName(["std", "bsl"], "basic_string") and
      this = call
    )
    or
    // string stream concat (operator<<)
    this.getTarget().hasQualifiedName(["std", "bsl"], "operator<<")
  }

  /**
   * Gets the operands of this concatenation (one of the string operands being
   * concatenated).
   * Will not return out param for sprintf-like functions, but will consider the format string
   * to be part of the operands.
   */
  Expr getAnOperand() {
    // The result is an argument of 'this' (a call)
    result = this.getAnArgument() and
    not result instanceof Call and // addresses odd behavior with overloaded operators
    // Limit the result type to string
    (
      result.getUnderlyingType().stripType().getName() = "char"
      or
      result.getUnderlyingType().getName() = "string"
      or
      result
          .getType()
          .getUnspecifiedType()
          .(UserType)
          .hasQualifiedName(["std", "bsl"], "basic_string")
    ) and
    // when 'this' is a `FormattingFunctionCall` the result must be the format string argument
    // or one of the formatting arguments
    (
      this instanceof FormattingFunctionCall
      implies
      (
        result = this.(FormattingFunctionCall).getFormat()
        or
        exists(int n |
          result = this.getArgument(n) and
          n >=
            this.(FormattingFunctionCall)
                .getTarget()
                .(FormattingFunction)
                .getFirstFormatArgumentIndex()
        )
      )
    )
  }

  /**
   * Gets the expression representing the concatenation result.
   */
  Expr getResultExpr() {
    if this instanceof FormattingFunctionCall
    then result = this.(FormattingFunctionCall).getOutputArgument(_)
    else result = this.(Call)
  }
}
