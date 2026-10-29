/**
 * @name Number of lines in files
 * @description The number of lines in each file.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @id js/lines-per-file
 */

import javascript

from File f, int n
where n = f.getNumberOfLines()
select f, n order by n desc
