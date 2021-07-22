/**
 * @name Lines of code in files
 * @kind treemap
 * @description Measures the number of lines of code in each file (ignoring lines that
 *              contain only docstrings, comments or are blank).
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @tags maintainability
 * @id py/lines-of-code-in-files
 */

import python

from Module m, int n
where n = m.getMetrics().getNumberOfLinesOfCode()
select m, n order by n desc
