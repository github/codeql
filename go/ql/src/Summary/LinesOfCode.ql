/**
 * @id go/summary/lines-of-code
 * @name Total lines of Go code in the database
 * @description The total number of lines of Go code across all extracted files, including auto-generated files. This is a useful metric of the size of a database. For all files that were seen during the build, this query counts the lines of code, excluding whitespace or comments.
 * @kind metric
 * @tags summary
 *       lines-of-code
 *       debug
 */

import go

select sum(GoFile f | | f.getNumberOfLinesOfCode())
