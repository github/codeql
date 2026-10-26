/**
 * @name OuterType
 */

import default

from TopLevelType t
where t.fromSource() and t.getFile().toString() = "A"
select t
