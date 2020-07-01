/**
 * @name Display strings of functions
 * @kind display-string
 * @id cpp/callable-display-strings
 * @metricType callable
 */

import cpp

from Function f
where f.fromSource()
select f, f.getName()
