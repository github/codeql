/**
 * @name Depends
 */

import default

from RefType rt1, RefType rt2
where rt1.fromSource() and depends(rt1, rt2)
select rt1, rt2.getQualifiedName()
