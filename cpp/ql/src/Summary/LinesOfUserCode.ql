/**
 * @id cpp/summary/lines-of-user-code
 * @name Total lines of C/C++ source code
 * @description The total number of lines of C/C++ code across all files, excluding system headers and libraries.
 * @kind metric
 * @tags summary
 */

import cpp

select sum(File f | exists(f.getRelativePath()) | f.getMetrics().getNumberOfLines())
