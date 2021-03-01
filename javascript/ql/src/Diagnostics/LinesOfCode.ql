/**
 * @name Total lines of code
 * @description The total number of lines of code across all source files.
 * @kind metric
 * @id js/metrics/lines-of-code
 */

import javascript

select sum(File f | not f.getATopLevel().isExterns() | f.getNumberOfLinesOfCode())
