/**
 * @name IsNestedType
 */

import default

from RefType t
where t.fromSource()
select t, t.getEnclosingType()
