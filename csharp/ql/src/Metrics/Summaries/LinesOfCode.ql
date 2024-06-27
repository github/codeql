/**
 * @id cs/summary/lines-of-code
 * @name Total lines of C# code in the database
 * @description The total number of lines of code across all files. This is a useful metric of the size of a database. For all files that were seen during the build, this query counts the lines of code, excluding whitespace or comments.
 * @kind metric
 * @tags summary
 *       lines-of-code
 *       debug
 */

import csharp

select sum(File f | f.fromSource() | f.getNumberOfLinesOfCode())
