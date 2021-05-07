/**
 * @name Errors When Using Bit Operations
 * @description Unlike the binary operations `||` and `&&`, there is no sequence point after evaluating an
 *              operand of a bitwise operation like `|` or `&`. If left-to-right evaluation is expected this may be confusing.
 * @kind problem
 * @id cpp/errors-when-using-bit-operations
 * @problem.severity warning
 * @precision medium
 * @tags correctness
 *       security
 *       external/cwe/cwe-691
 */

import cpp
import semmle.code.cpp.valuenumbering.GlobalValueNumbering

/**
 * Dangerous uses of bit operations.
 * For example: `if(intA>0 & intA<10 & charBuf&myFunc(charBuf[intA]))`.
 * In this case, the function will be called in any case, and even the sequence of the call is not guaranteed.
 */
class DangerousBitOperations extends BinaryBitwiseOperation {
  FunctionCall bfc;

  /**
   * The assignment indicates the conscious use of the bit operator.
   * Use in comparison, conversion, or return value indicates conscious use of the bit operator.
   * The use of shifts and bitwise operations on any element of an expression indicates a conscious use of the bitwise operator.
   */
  DangerousBitOperations() {
    bfc = this.getRightOperand() and
    not this.getParent*() instanceof Assignment and
    not this.getParent*() instanceof Initializer and
    not this.getParent*() instanceof ReturnStmt and
    not this.getParent*() instanceof EqualityOperation and
    not this.getParent*() instanceof UnaryLogicalOperation and
    not this.getParent*() instanceof BinaryLogicalOperation and
    not this.getAChild*() instanceof BitwiseXorExpr and
    not this.getAChild*() instanceof LShiftExpr and
    not this.getAChild*() instanceof RShiftExpr
  }

  /** Holds when part of a bit expression is used in a logical operation. */
  predicate useInLogicalOperations() {
    exists(BinaryLogicalOperation blop, Expr exp |
      blop.getAChild*() = exp and
      exp.(FunctionCall).getTarget() = bfc.getTarget() and
      not exp.getParent() instanceof ComparisonOperation and
      not exp.getParent() instanceof BinaryBitwiseOperation
    )
  }

  /** Holds when part of a bit expression is used as part of another supply. For example, as an argument to another function. */
  predicate useInOtherCalls() {
    bfc.hasQualifier() or
    bfc.getTarget() instanceof Operator or
    exists(FunctionCall fc | fc.getAnArgument().getAChild*() = this) or
    bfc.getTarget() instanceof BuiltInFunction
  }

  /** Holds when the bit expression contains both arguments and a function call. */
  predicate dangerousArgumentChecking() {
    not this.getLeftOperand() instanceof Call and
    globalValueNumber(this.getLeftOperand().getAChild*()) = globalValueNumber(bfc.getAnArgument())
  }

  /** Holds when function calls are present in the bit expression. */
  predicate functionCallsInBitsExpression() {
    this.getLeftOperand().getAChild*() instanceof FunctionCall
  }
}

from DangerousBitOperations dbo
where
  not dbo.useInOtherCalls() and
  dbo.useInLogicalOperations() and
  (not dbo.functionCallsInBitsExpression() or dbo.dangerousArgumentChecking())
select dbo, "This bitwise operation appears in a context where a Boolean operation is expected."
