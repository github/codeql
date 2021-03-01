/**
 * @name Total lines of text
 * @description The total number of lines of text across all source files.
 * @kind metric
 * @id js/metrics/lines
 */

import javascript

select sum(File f | not f.getATopLevel().isExterns() | f.getNumberOfLines())
