/**
 * @name Lines of text per source file
 * @description The number of lines of text for each source file.
 * @kind metric
 * @id cpp/metrics/lines-per-file
 */

import cpp

from File f
where f.fromSource()
select f, f.getMetrics().getNumberOfLines()
