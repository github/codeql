/**
 * @name AV Rule 157
 * @description The right hand operand of a && or || operator shall not
 *              contain side effects.
 * @kind problem
 * @id cpp/jsf/av-rule-157
 * @problem.severity warning
 * @tags correctness
 *       readability
 *       external/jsf
 */

import cpp

/*
 * See MISRA Rule 5-14-1
 */

from BinaryLogicalOperation blo
where
  blo.fromSource() and
  not blo.getRightOperand().isPure()
select blo,
  "AV Rule 157: The right hand operand of a && or || operator shall not contain side effects."
