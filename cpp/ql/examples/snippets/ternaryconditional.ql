/**
 * @id cpp/examples/ternaryconditional
 * @name Conditional expressions
 * @description Finds conditional expressions of the form `... ? ... : ...`
 *              where the types of the resulting expressions differ
 * @tags conditional
 *       ternary
 *       type
 */

import cpp

from ConditionalExpr e
where e.getThen().getType() != e.getElse().getType()
select e
