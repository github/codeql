/**
 * @name Number of lines
 * @kind metric
 * @description The number of lines in each file.
 * @metricType file
 * @id ql/lines-per-file
 */

import ql

from File f, int n
where n = f.getNumberOfLines()
select f, n order by n desc
