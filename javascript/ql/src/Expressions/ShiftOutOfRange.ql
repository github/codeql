/**
 * @name Shift out of range
 * @description The shift operators '<<', '>>' and '>>>' only take the five least significant bits of their
 *              right operand into account. Thus, it is not possible to shift by more than 31 bits.
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
where shift.getRightOperand().getIntValue() > 31
select shift, "Shift out of range."