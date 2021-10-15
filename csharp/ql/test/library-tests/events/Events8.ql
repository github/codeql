/**
 * @name Test for events
 */

import csharp

where forall(Event e | exists(e.getAddEventAccessor()) implies exists(e.getRemoveEventAccessor()))
select 1
