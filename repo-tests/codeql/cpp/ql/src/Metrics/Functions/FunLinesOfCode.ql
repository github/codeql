/**
 * @name Lines of code per function
 * @description Measures the number of lines in a function that contain
 *              code (rather than lines that only contain comments or
 *              are blank).
 * @kind treemap
 * @id cpp/lines-of-code-per-function
 * @treemap.warnOn highValues
 * @metricType callable
 * @metricAggregate avg sum max
 * @tags maintainability
 */

import cpp

from Function f
where strictcount(f.getEntryPoint()) = 1
select f, f.getMetrics().getNumberOfLinesOfCode()
