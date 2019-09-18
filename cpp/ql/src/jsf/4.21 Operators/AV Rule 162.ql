/**
 * @name AV Rule 162
 * @description Signed and unsigned values shall not be mixed in arithmetic or comparison operations. Mixing signed and unsigned values is error prone as it subjects operations to numerous arithmetic conversion and integral promotion rules.
 * @kind problem
 * @id cpp/jsf/av-rule-162
 * @problem.severity warning
 * @tags correctness
 *       external/jsf
 */

import cpp

predicate excluded(Expr e) {
  // Don't bother with literals - signed/unsigned is less meaningful there
  e instanceof Literal
}

predicate isSignedOperand(Expr e) {
  e.getExplicitlyConverted().getUnderlyingType().(IntegralType).isSigned() and
  not excluded(e)
}

predicate isUnsignedOperand(Expr e) {
  e.getExplicitlyConverted().getUnderlyingType().(IntegralType).isUnsigned() and
  not excluded(e)
}

from BinaryOperation op
where
  (op instanceof BinaryArithmeticOperation or op instanceof ComparisonOperation) and
  isSignedOperand(op.getAnOperand()) and
  isUnsignedOperand(op.getAnOperand())
select op,
  "AV Rule 162: signed and unsigned values shall not be mixed in arithmetic or comparison operations"
