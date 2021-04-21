/**
 * @name Number of lines
 * @kind metric
 * @description The number of lines in each file.
 * @metricType file
 * @id rb/lines-per-file
 * @tags maintainability
 */

import ruby

from File f, int n
where n = f.getMetrics().getNumberOfLines()
select f, n order by n desc
