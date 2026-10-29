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
  e.getThen().getType() != e.getElse().getType() and
  not e.getThen().getType() instanceof NullType and
  not e.getElse().getType() instanceof NullType
select e
