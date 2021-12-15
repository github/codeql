/**
 * @name Shift out of range
 * @description The integer shift operators '<<', '>>' and '>>>' only take the five least significant bits of their
 *              right operand into account. Thus, it is not possible to shift an integer by more than 31 bits.
 * @kind problem
 * @problem.severity error
 * @id js/shift-out-of-range
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-197
 * @precision very-high
 */

import javascript

from ShiftExpr shift
where
  shift.getRightOperand().getIntValue() > 31 and
  not shift.getRightOperand().stripParens() instanceof BigIntLiteral
select shift, "Shift out of range."
