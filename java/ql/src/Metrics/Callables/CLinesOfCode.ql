/**
 * @name Lines of code in methods
 * @description The number of lines of code in a method.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType callable
 * @metricAggregate avg sum max
 * @id java/lines-of-code-per-function
 * @tags maintainability
 *       complexity
 */

import java

from Callable c
where c.fromSource()
select c, c.getMetrics().getNumberOfLinesOfCode() as n order by n desc
