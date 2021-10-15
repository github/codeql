/**
 * @id cpp/examples/castexpr
 * @name Cast expressions
 * @description Finds casts from a floating point type to an integer type
 * @tags cast
 *       integer
 *       float
 *       type
 */

import cpp

from Cast c
where
  c.getExpr().getType() instanceof FloatingPointType and
  c.getType() instanceof IntegralType
select c
