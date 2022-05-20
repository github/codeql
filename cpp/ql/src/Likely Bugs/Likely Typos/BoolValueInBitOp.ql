/**
 * @name Boolean value in bitwise operation
 * @description A Boolean value (i.e. something that has been coerced to have
 *              a value of either 0 or 1) is used in a bitwise operation.
 *              This commonly indicates missing parentheses or mistyping
 *              logical operators as bitwise operators.
 * @kind problem
 * @id cpp/bool-value-in-bit-op
 * @problem.severity warning
 * @tags reliability
 */

import cpp

class BitwiseOperation extends Expr {
  BitwiseOperation() {
    this instanceof BinaryBitwiseOperation or
    this instanceof UnaryBitwiseOperation
  }
}

class LogicalOperation extends Expr {
  LogicalOperation() {
    this instanceof BinaryLogicalOperation or
    this instanceof UnaryLogicalOperation or
    this instanceof ComparisonOperation
  }
}

/**
 * It's common in some projects to use "non-short-circuit logic", i.e. to
 * apply the bitwise and, or and xor operators to Boolean values. Such use,
 * while considered bad practice, is usually not incorrect.
 */
predicate nonShortCircuitLogic2(BinaryBitwiseOperation op) {
  (op instanceof BitwiseAndExpr or op instanceof BitwiseOrExpr or op instanceof BitwiseXorExpr) and
  (op.getLeftOperand() instanceof LogicalOperation or nonShortCircuitLogic2(op.getLeftOperand())) and
  (op.getRightOperand() instanceof LogicalOperation or nonShortCircuitLogic2(op.getRightOperand()))
}

from LogicalOperation o
where
  o.getParent() instanceof BitwiseOperation and
  not nonShortCircuitLogic2(o.getParent()) and
  not o.getParent().isInMacroExpansion() and // It's ok if o itself is in a macro expansion.
  not o.getParent().(LShiftExpr).getLeftOperand() = o // Common pattern for producing bit masks: "(a && b) << 16".
select o, "The result of this expression is Boolean, but it is used in a bitwise context."
