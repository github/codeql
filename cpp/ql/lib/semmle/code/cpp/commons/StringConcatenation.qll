/**
 * A library for detecting general string concatenations.
 */

import cpp
import semmle.code.cpp.models.implementations.Strcat
import semmle.code.cpp.models.interfaces.FormattingFunction
private import semmle.code.cpp.dataflow.new.DataFlow

/**
 * A call that performs a string concatenation. A string can be either a C
 * string (i.e., a value of type `char*`), or a C++ string (i.e., a value of
 * type `std::string`).
 */
class StringConcatenation extends Call {
  StringConcatenation() {
    // sprintf-like functions, i.e., concat through formatting
    this instanceof FormattingFunctionCall
    or
    this.getTarget() instanceof StrcatFunction
    or
    this.getTarget() instanceof StrlcatFunction
    or
    // operator+ and ostream (<<) concat
    exists(Call call, Operator op |
      call.getTarget() = op and
      op.hasQualifiedName(["std", "bsl"], ["operator+", "operator<<"]) and
      op.getType()
          .stripType()
          .(UserType)
          .hasQualifiedName(["std", "bsl"], ["basic_string", "basic_ostream"]) and
      this = call
    )
  }

  /**
   * Gets an operand of this concatenation (one of the string operands being
   * concatenated).
   * Will not return out param for sprintf-like functions, but will consider the format string
   * to be part of the operands.
   */
  Expr getAnOperand() {
    // The result is an argument of 'this' (a call)
    result = this.getAnArgument() and
    // addresses odd behavior with overloaded operators
    // i.e., "call to operator+" appearing as an operand
    // occurs in cases like `string s = s1 + s2 + s3`, which is represented as
    // `string s = (s1.operator+(s2)).operator+(s3);`
    // By limiting to non-calls we get the leaf operands (the variables or raw strings)
    // also, by not enumerating allowed types (variables and strings) we avoid issues
    // with missed corner cases or extensions/changes to CodeQL in the future which might
    // invalidate that approach.
    not result instanceof Call and
    // Limit the result type to string
    (
      result.getUnderlyingType().stripType().getName() = "char"
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
          n >= this.(FormattingFunctionCall).getTarget().getFirstFormatArgumentIndex()
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
      result.asExpr() = this.(Call)
    else
      if this.getTarget() instanceof StrlcatFunction
      then (
        result.asDefiningArgument() =
          this.getArgument(this.getTarget().(StrlcatFunction).getParamDest())
      ) else
        if this instanceof FormattingFunctionCall
        then result.asDefiningArgument() = this.(FormattingFunctionCall).getOutputArgument(_)
        else result.asExpr() = this.(Call)
  }
}
