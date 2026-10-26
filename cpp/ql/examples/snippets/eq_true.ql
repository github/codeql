/**
 * @id cpp/examples/eq-true
 * @name Equality test on boolean
 * @description Finds tests like `==true`, `!=true`
 * @tags equal
 *       comparison
 *       test
 *       boolean
 */

import cpp

from EqualityOperation eq, Expr trueExpr
where
  trueExpr = eq.getAnOperand() and
  trueExpr.getType() instanceof BoolType and
  trueExpr.getValue().toInt() = 1
select eq
