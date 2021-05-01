/**
 * @name IsInType
 */

import default

from Element e, RefType t
where t.hasChildElement*(e) and e.fromSource() and e.getFile().getAbsolutePath() = "A"
select e, t
