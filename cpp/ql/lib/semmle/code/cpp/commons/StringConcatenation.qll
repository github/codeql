/**
 * A library for detecting general string concatenations.
 */

import cpp
import semmle.code.cpp.models.implementations.Strcat
import semmle.code.cpp.models.interfaces.FormattingFunction
private import semmle.code.cpp.dataflow.new.DataFlow

class StringConcatenation extends Call {
  StringConcatenation() {
    // sprintf-like functions, i.e., concat through formatting
    this instanceof FormattingFunctionCall
    or
    this.getTarget() instanceof StrcatFunction
    or
    this.getTarget() instanceof StrlcatFunction
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
    // addresses odd behavior with overloaded operators
    // i.e., "call to operator+" appearing as an operand
    not result instanceof Call and
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
   * Gets the data flow node representing the concatenation result.
   */
  DataFlow::Node getResultNode() {
    if this.getTarget() instanceof StrcatFunction
    then
      result.asDefiningArgument() =
        this.getArgument(this.getTarget().(StrcatFunction).getParamDest())
      or
      // Hardcoding it is also the return
      [result.asExpr(), result.asIndirectExpr()] = this.(Call)
    else
      if this.getTarget() instanceof StrlcatFunction
      then (
        [result.asExpr(), result.asIndirectExpr()] =
          this.getArgument(this.getTarget().(StrlcatFunction).getParamDest())
      ) else
        if this instanceof FormattingFunctionCall
        then
          [result.asExpr(), result.asIndirectExpr()] =
            this.(FormattingFunctionCall).getOutputArgument(_)
        else [result.asExpr(), result.asIndirectExpr()] = this.(Call)
  }
}
