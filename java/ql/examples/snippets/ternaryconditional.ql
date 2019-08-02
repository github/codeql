/**
 * @id java/examples/ternaryconditional
 * @name Conditional expressions
 * @description Finds conditional expressions of the form '... ? ... : ...'
 *              where the types of the resulting expressions differ
 * @tags conditional
 *       type
 */

import java

from ConditionalExpr e
where
  e.getTrueExpr().getType() != e.getFalseExpr().getType() and
  not e.getTrueExpr().getType() instanceof NullType and
  not e.getFalseExpr().getType() instanceof NullType
select e
