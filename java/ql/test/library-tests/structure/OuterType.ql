/**
 * @name OuterType
 */

import default

from TopLevelType t
where t.fromSource() and t.getFile().getAbsolutePath() = "A"
select t
