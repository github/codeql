/**
 * @name Lines of code in files
 * @kind metric
 * @description Measures the number of lines of code in each file, ignoring lines that
 *              contain only comments or whitespace.
 * @metricType file
 * @id rb/lines-of-code-in-files
 */

import ruby

from RubyFile f, int n
where n = f.getNumberOfLinesOfCode()
select f, n order by n desc
