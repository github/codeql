/**
 * @name Source links of functions
 * @kind source-link
 * @id cpp/callable-source-links
 * @metricType callable
 */

import cpp

from Function f
where f.fromSource()
select f, f.getFile()
