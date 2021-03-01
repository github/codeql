/**
 * @name Lines of text per source file
 * @description The number of lines of text for each source file.
 * @kind metric
 * @id js/metrics/lines-per-file
 */

import javascript

from File f
where not f.getATopLevel().isExterns()
select f, f.getNumberOfLines()
