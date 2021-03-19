/**
 * @id js/summary/lines-of-code
 * @name Total lines of JavaScript and TypeScript code in the database
 * @description The total number of lines of JavaScript or TypeScript code across all files checked into the repository, except in `node_modules`. This is a useful metric of the size of a database. For all files that were seen during extraction, this query counts the lines of code, excluding whitespace or comments.
 * @kind metric
 * @tags summary
 */

import javascript

select sum(File f | not f.getATopLevel().isExterns() | f.getNumberOfLinesOfCode())
