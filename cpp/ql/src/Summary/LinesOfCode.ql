/**
 * @id cpp/summary/lines-of-code
 * @name Total lines of C/C++ code
 * @description The total number of lines of C/C++ code across all files, including system headers and libraries.
 * @kind metric
 * @tags summary
 */

import cpp

select sum(File f | f.fromSource() | f.getMetrics().getNumberOfLines())
