/**
 * @name Number of lines
 * @description The number of lines in each file.
 * @kind treemap
 * @treemap.warnOn highValues
 * @id java/lines-per-file
 * @metricType file
 * @metricAggregate avg sum max
 */

import java

from File f, int n
where n = f.getTotalNumberOfLines()
select f, n order by n desc
