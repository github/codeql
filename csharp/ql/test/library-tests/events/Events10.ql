/**
 * @name Test for events
 */

import csharp

where count(RemoveEventAccessor e | e.fromSource()) = 3
select 1
