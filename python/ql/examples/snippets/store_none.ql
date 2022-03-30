/**
 * @id py/examples/store-none
 * @name Store None to collection
 * @description Finds places where `None` is used as an index when storing to a collection
 * @tags None
 *       parameter
 *       argument
 *       collection
 *       add
 */

import python

from SubscriptNode store
where
  store.isStore() and
  store.getIndex().pointsTo(Value::named("None"))
select store
