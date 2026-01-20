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
private import LegacyPointsTo

from SubscriptNode store
where
  store.isStore() and
  store.getIndex().(ControlFlowNodeWithPointsTo).pointsTo(Value::named("None"))
select store
