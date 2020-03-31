/**
 * @name Lines of code in functions
 * @description The number of lines of code in a function.
 * @kind treemap
 * @id py/lines-of-code-per-function
 * @treemap.warnOn highValues
 * @metricType callable
 * @metricAggregate avg sum max
 * @tags maintainability
 */

import python

from Function f
select f, f.getMetrics().getNumberOfLinesOfCode() as n order by n desc
