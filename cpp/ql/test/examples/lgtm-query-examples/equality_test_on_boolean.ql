/**
 * @name Equality test on Boolean
 * @description Testing equality with `true` is redundant
 *              and can make the code harder to read.
 * @kind problem
 * @problem.severity warning
 */

import cpp

from EqualityOperation eq, Expr trueExpr
where
  trueExpr = eq.getAnOperand() and
  trueExpr.getType() instanceof BoolType and
  trueExpr.getValue().toInt() = 1
select eq, "Expression tested for equality with 'true'"
