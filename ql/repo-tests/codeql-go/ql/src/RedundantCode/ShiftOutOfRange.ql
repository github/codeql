/**
 * @name Shift out of range
 * @description Shifting by more than the number of bits in the type of the left-hand
 *              side always yields 0 or -1.
 * @kind problem
 * @problem.severity warning
 * @id go/shift-out-of-range
 * @precision very-high
 * @tags correctness
 *       external/cwe/cwe-197
 */

import go

from ShiftExpr sh, IntegerType ltp, int maxsz, int amt, string atmost
where
  ltp = sh.getLeftOperand().getType() and
  (if exists(ltp.getSize()) then atmost = "" else atmost = "(at most) ") and
  maxsz = max(ltp.getASize()) and
  amt = sh.getRightOperand().getIntValue() and
  not ltp.getASize() > amt
select sh,
  "Shifting a value of " + atmost + maxsz + " bits by " + amt + " always yields either 0 or -1."
