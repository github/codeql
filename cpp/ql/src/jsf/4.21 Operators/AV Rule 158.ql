/**
 * @name AV Rule 158
 * @description The operands of a logical && or || operator shall be parenthesized
 *              if the operands contain binary operators.
 * @kind problem
 * @id cpp/jsf/av-rule-158
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp

/*
 * NB: we only check if the immediate operands are (unparenthesised) binary operations
 */

from BinaryLogicalOperation blo, BinaryOperation bo
where
  blo.fromSource() and
  bo = blo.getAnOperand() and
  not bo.isParenthesised()
select blo,
  "AV Rule 158: The operands of a logical && or || operator shall be parenthesized if the operands contain binary operators."
