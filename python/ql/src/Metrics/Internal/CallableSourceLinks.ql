/**
 * @name Source links of callables
 * @kind source-link
 * @id py/function-source-links
 * @metricType callable
 */

import python

from Function f
select f, f.getLocation().getFile()
