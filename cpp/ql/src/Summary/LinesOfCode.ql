/**
 * @id cpp/summary/lines-of-code
 * @name Total lines of C/C++ code in the database
 * @description The total number of lines of C/C++ code across all files, including system headers, libraries, and auto-generated files. This is a useful metric of the size of a database. Lines of code are all lines in a file that was seen during the build that contain code, i.e. are not whitespace or comments.
 * @kind metric
 * @tags summary
 */

import cpp

select sum(File f | f.fromSource() | f.getMetrics().getNumberOfLinesOfCode())
