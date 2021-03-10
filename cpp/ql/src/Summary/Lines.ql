/**
 * @id cpp/summary/lines
 * @name Total lines of text
 * @description The total number of lines of text across all source files.
 * @kind metric
 * @tags summary
 */

import cpp

select sum(File f | f.fromSource() | f.getMetrics().getNumberOfLines())
