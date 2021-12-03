/**
 * @name Total lines of Python code in the database
 * @description The total number of lines of Python code across all files, including
 *   external libraries and auto-generated files. This is a useful metric of the size of a
 *   database. This query counts the lines of code, excluding whitespace or comments.
 * @kind metric
 * @tags summary
 * @id py/summary/lines-of-code
 */

import python

select sum(Module m | | m.getMetrics().getNumberOfLinesOfCode())
