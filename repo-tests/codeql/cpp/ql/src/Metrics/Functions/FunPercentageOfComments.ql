/**
 * @name Comment ratio per function
 * @description The ratio of comment lines to the total number of lines
 *              in a function.
 * @kind treemap
 * @id cpp/percentage-of-comments-per-function
 * @treemap.warnOn lowValues
 * @metricType callable
 * @metricAggregate avg max
 * @tags maintainability
 *       documentation
 */

import cpp

from MetricFunction f
where f.getNumberOfLines() > 0 and strictcount(f.getEntryPoint()) = 1
select f, 100.0 * (f.getNumberOfLinesOfComments().(float) / f.getNumberOfLines().(float))
