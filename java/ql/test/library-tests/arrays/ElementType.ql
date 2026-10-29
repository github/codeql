/**
 * @name ElementType
 */

import default

from Array a
where exists(ArrayTypeAccess access | access.getType() = a)
select a.toString(), a.getElementType().toString()
