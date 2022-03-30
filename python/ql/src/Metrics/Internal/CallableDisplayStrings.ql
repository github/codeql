/**
 * @name Display strings of callables
 * @kind display-string
 * @id py/function-display-strings
 * @metricType callable
 */

import python

from Function f
select f, "Function " + f.getName()
