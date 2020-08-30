/**
 * @id py/examples/conditional-expression
 * @name Conditional expressions
 * @description Finds conditional expressions of the form '... if ... else ...'
 *              where the classes of the sub-expressions differ
 * @tags conditional
 *       expression
 *       ternary
 */

import python

from IfExp e, ClassObject cls1, ClassObject cls2
where
  e.getBody().refersTo(_, cls1, _) and
  e.getOrelse().refersTo(_, cls2, _) and
  cls1 != cls2
select e
