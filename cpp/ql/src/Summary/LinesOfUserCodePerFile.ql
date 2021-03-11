/**
 * @id cpp/summary/lines-of-user-code-per-file
 * @name Lines of C/C++ code per source file
 * @description The number of lines of C/C++ code for each file in the source directory.
 * @kind metric
 * @tags summary
 */

import cpp

from File f
where exists(f.getRelativePath())
select f, f.getMetrics().getNumberOfLines()
