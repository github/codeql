/**
 * @id cpp/summary/lines-of-code-per-file
 * @name Lines of C/C++ code per source file
 * @description The number of lines of C/C++ code for each file in the database, including system headers and libraries.
 * @kind metric
 * @tags summary
 */

import cpp

from File f
where f.fromSource()
select f, f.getMetrics().getNumberOfLines()
