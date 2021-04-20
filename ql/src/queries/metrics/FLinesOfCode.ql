/**
 * @name Lines of code in files
 * @kind treemap
 * @description Measures the number of lines of code in each file, ignoring lines that
 *              contain only comments or whitespace.
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @precision very-high
 * @id rb/lines-of-code-in-files
 * @tags maintainability
 */

import ruby

from File f, int n
where n = f.getMetrics().getNumberOfLinesOfCode()
select f, n order by n desc
