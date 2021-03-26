/**
 * @name Lines of code in functions
 * @description The number of lines of code in a function.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType callable
 * @metricAggregate avg sum max
 * @tags maintainability
 * @id js/lines-of-code-per-function
 */

import javascript

from Function f
select f, f.getNumberOfLinesOfCode() as n order by n desc
