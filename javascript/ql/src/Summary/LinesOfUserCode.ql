/**
 * @name Total lines of user written JavaScript and TypeScript code in the database
 * @description The total number of lines of JavaScript and TypeScript code from the source code directory,
 *   excluding auto-generated files and files in `node_modules`. This query counts the lines of code, excluding
 *   whitespace or comments.
 * @kind metric
 * @tags summary
 *       lines-of-code
 *       debug
 * @id js/summary/lines-of-user-code
 */

import javascript
import semmle.javascript.GeneratedCode

select sum(File f |
    not f.getATopLevel().isExterns() and
    exists(f.getRelativePath()) and
    not isGeneratedCode(f)
  |
    f.getNumberOfLinesOfCode()
  )
