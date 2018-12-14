/**
 * @name UsesType
 */

import default

from Type t, RefType rt
where usesType(t, rt) and rt.fromSource()
select t, rt
