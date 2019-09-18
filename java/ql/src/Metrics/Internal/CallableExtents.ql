/**
 * @name Extents of callables
 * @kind extent
 * @metricType callable
 * @id java/callable-extents
 */

import java
import Extents

from RangeCallable c
where c.fromSource()
select c.getLocation(), c
