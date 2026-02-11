/**
 * @id py/examples/raise-exception
 * @name Raise exception of a class
 * @description Finds places where we raise AnException or one of its subclasses
 * @tags throw
 *       raise
 *       exception
 */

import python
private import LegacyPointsTo

from Raise raise, ClassValue ex
where
  ex.getName() = "AnException" and
  raise.getException().(ExprWithPointsTo).pointsTo(ex.getASuperType())
select raise, "Don't raise instances of 'AnException'"
