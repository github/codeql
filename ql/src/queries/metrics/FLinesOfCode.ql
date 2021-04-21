/**
 * @name Lines of code in files
 * @kind metric
 * @description Measures the number of lines of code in each file, ignoring lines that
 *              contain only comments or whitespace.
 * @metricType file
 * @id rb/lines-of-code-in-files
 * @tags maintainability
 */

import ruby

from File f, int n
where n = f.getNumberOfLinesOfCode()
select f, n order by n desc
