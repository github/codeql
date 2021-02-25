/**
 * @name Lines of code per source file
 * @description The number of lines of code for each source file.
 * @kind metric
 * @id cpp/metrics/lines-of-code-per-file
 */

import cpp

from File f
where f.fromSource()
select f, f.getMetrics().getNumberOfLinesOfCode()
