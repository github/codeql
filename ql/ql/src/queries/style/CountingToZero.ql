/**
 * @name Counting zero elements
 * @description Use not exists instead of checking that there is zero elements in a set.
 * @kind problem
 * @problem.severity warning
 * @id ql/counting-to-zero
 * @precision high
 */

import ql

from ComparisonFormula comp, int c, string msg
where
  c = 0 and // [0, 1] and // skipping the 1 case for now, as it seems too noisy.
  comp.getOperator() = ["=", "!="] and
  comp.getAnOperand().(Integer).getValue() = c and
  comp.getAnOperand().(Aggregate).getKind() = ["count", "strictcount"] and
  if c = 0
  then msg = "Use not exists(..) instead of checking that there is zero elements in a set."
  else msg = "Use unique(.. | |) instead of checking that there is one element in a set."
select comp, msg
