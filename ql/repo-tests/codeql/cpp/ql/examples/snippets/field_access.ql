/**
 * @id cpp/examples/field-access
 * @name Access of field
 * @description Finds reads of `aDate` (defined on class `Order`)
 * @tags access
 *       field
 *       read
 */

import cpp

from Field f, FieldAccess access
where
  f.hasName("aDate") and
  f.getDeclaringType().hasName("Order") and
  f = access.getTarget()
select access
