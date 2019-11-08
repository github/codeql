/**
 * @name Lines of code in files
 * @description Measures the number of lines of code in each file, ignoring lines that
 *              contain only comments or whitespace.
 * @kind metric
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @precision very-high
 * @id go/lines-of-code-in-files
 * @tags maintainability
 */

import go

from File f, int n
where n = f.getNumberOfLinesOfCode()
select f, n order by n desc
