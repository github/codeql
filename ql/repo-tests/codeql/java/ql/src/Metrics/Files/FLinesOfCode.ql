/**
 * @name Lines of code in files
 * @description The number of lines of code in a file.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @id java/lines-of-code-in-files
 * @tags maintainability
 *       complexity
 */

import java

from File f, int n
where n = f.getNumberOfLinesOfCode()
select f, n order by n desc
