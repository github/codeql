/**
 * @name Lines of code in files
 * @kind treemap
 * @description Measures the number of lines of code in each file, ignoring lines that
 *              contain only comments or whitespace.
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @id js/lines-of-code-in-files
 * @tags maintainability
 */

import javascript

from File f, int n
where n = f.getNumberOfLinesOfCode()
select f, n order by n desc
