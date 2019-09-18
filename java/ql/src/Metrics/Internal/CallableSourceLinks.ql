/**
 * @name Source links of callables
 * @kind source-link
 * @metricType callable
 * @id java/callable-source-links
 */

import java

from Callable c
where c.fromSource()
select c, c.getFile()
