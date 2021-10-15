/**
 * @name IsTopLevelType
 */

import default

from TopLevelType tp
where tp.fromSource() and tp.getFile().toString() = "A"
select tp, tp.getPackage()
