/**
 * @id rb/summary/lines-of-code
 * @name Total lines of Ruby code in the database
 * @description The total number of lines of Ruby code across all files,
 *   including vendored code, tests. This query counts the lines of code,
 *   excluding whitespace or comments.
 * @kind metric
 * @tags summary
 */

import ruby

select sum(File f | | f.getNumberOfLinesOfCode())
