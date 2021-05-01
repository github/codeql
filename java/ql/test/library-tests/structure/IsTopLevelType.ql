/**
 * @name IsTopLevelType
 */

import default

from TopLevelType tp
where tp.fromSource() and tp.getFile().getAbsolutePath() = "A"
select tp, tp.getPackage()
