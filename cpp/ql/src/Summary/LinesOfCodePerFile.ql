/**
 * @id cpp/summary/lines-of-code-per-file
 * @name Lines of code per source file
 * @description The number of lines of code for each source file.
 * @kind metric
 * @tags summary
 */

import cpp

from File f
where f.fromSource()
select f, f.getMetrics().getNumberOfLinesOfCode()
