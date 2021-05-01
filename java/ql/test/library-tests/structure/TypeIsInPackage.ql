/**
 * @name TypeIsInPackage
 */

import default

from RefType tp
where tp.fromSource() and tp.getFile().getAbsolutePath() = "A"
select tp, tp.getPackage()
