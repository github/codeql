/**
 * @name AV Rule 202
 * @description Floating point variables shall not be tested for exact equality or inequality.
 * @kind problem
 * @id cpp/jsf/av-rule-202
 * @problem.severity error
 * @tags correctness
 *       external/jsf
 */

import cpp

/*
 * See MISRA 6-2-2
 */

from EqualityOperation e
where
  e.fromSource() and
  e.getAnOperand().getType() instanceof FloatingPointType
select e,
  "AV Rule 202: Floating point variables shall not be tested for exact equality or inequality."
