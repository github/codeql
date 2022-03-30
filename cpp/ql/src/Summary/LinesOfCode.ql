/**
 * @id cpp/summary/lines-of-code
 * @name Total lines of C/C++ code in the database
 * @description The total number of lines of C/C++ code across all files, including system headers, libraries, and auto-generated files. This is a useful metric of the size of a database. For all files that were seen during the build, this query counts the lines of code, excluding whitespace or comments.
 * @kind metric
 * @tags summary
 */

import cpp

select sum(File f | f.fromSource() | f.getMetrics().getNumberOfLinesOfCode())
