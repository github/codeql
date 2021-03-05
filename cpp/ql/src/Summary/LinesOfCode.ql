/**
 * @name Total lines of code
 * @description The total number of lines of code across all source files.
 * @kind metric
 * @id cpp/summary/lines-of-code
 */

import cpp

select sum(File f | f.fromSource() | f.getMetrics().getNumberOfLinesOfCode())
