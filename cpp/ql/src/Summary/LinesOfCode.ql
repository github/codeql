/**
 * @id cpp/summary/lines-of-code
 * @name Total lines of C/C++ code in the database.
 * @description The total number of lines of C/C++ code across all files, including system headers and libraries. This is a useful metric of the size of a database.
 * @kind metric
 * @tags summary
 */

import cpp

select sum(File f | f.fromSource() | f.getMetrics().getNumberOfLines())
