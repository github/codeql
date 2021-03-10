/**
 * @id cpp/summary/lines-per-file
 * @name Lines of text per source file
 * @description The number of lines of text for each source file.
 * @kind metric
 * @tags summary
 */

import cpp

from File f
where f.fromSource()
select f, f.getMetrics().getNumberOfLines()
