/**
 * @id cs/examples/ternary-conditional
 * @name Conditional expressions
 * @description Finds conditional expressions of the form '... ? ... : ...'
 *              where the types of the resulting expressions differ.
 * @tags conditional
 *       type
 */

import csharp

from ConditionalExpr e
where
  e.getThen().stripImplicitCasts() != e.getElse().stripImplicitCasts() and
  not e.getThen().getType() instanceof NullType and
  not e.getElse().getType() instanceof NullType
select e
