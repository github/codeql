/**
 * @name Lines of comments per function
 * @description Measures the number of lines in a function that contain
 *              a comment or part of a comment (that is, which are part
 *              of a multi-line comment).
 * @kind treemap
 * @id cpp/lines-of-comments-per-function
 * @treemap.warnOn lowValues
 * @metricType callable
 * @metricAggregate avg sum max
 * @tags maintainability
 *       documentation
 */

import cpp

from Function f
where strictcount(f.getEntryPoint()) = 1
select f, f.getMetrics().getNumberOfLinesOfComments()
