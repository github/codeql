/**
 * @name Extents of reftypes
 * @kind extent
 * @metricType reftype
 * @id java/reference-type-extents
 */

import java
import Extents

from RangeRefType t
where t.fromSource()
select t.getLocation(), t
