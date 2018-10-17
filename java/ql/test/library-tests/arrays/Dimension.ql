/**
 * @name Dimension
 */

import default

from Array a
where exists(ArrayTypeAccess access | access.getType() = a)
select a.toString(), a.getDimension()
