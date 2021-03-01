/**
 * @name Lines of code per source file
 * @description The number of lines of code for each source file.
 * @kind metric
 * @id js/metrics/lines-of-code-per-file
 */

import javascript

from File f
where not f.getATopLevel().isExterns()
select f, f.getNumberOfLinesOfCode()
