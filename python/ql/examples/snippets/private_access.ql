/**
 * @id py/examples/private-access
 * @name Private access
 * @description Find accesses to "private" attributes (those starting with an underscore)
 * @tags access
 *       private
 */

import python

predicate is_private(Attribute a) {
  a.getName().matches("\\_%") and
  not a.getName().matches("\\_\\_%\\_\\_")
}

from Attribute access
where
  is_private(access) and
  not access.getObject().(Name).getId() = "self"
select access
