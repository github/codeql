/**
 * @name Lines of code in files
 * @kind metric
 * @description Measures the number of lines of code in each file, ignoring lines that
 *              contain only comments or whitespace.
 * @metricType file
 * @id ql/lines-of-code-in-files
 */

import ql

from File f, int n
where n = f.getNumberOfLinesOfCode()
select f, n order by n desc
