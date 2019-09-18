/**
 * @name TypeIsInPackage
 */

import default

from RefType tp
where tp.fromSource() and tp.getFile().toString() = "A"
select tp, tp.getPackage()
