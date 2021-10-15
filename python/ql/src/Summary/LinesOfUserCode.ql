/**
 * @name Total lines of user written Python code in the database
 * @description The total number of lines of Python code from the source code directory,
 *   excluding auto-generated files. This query counts the lines of code, excluding
 *   whitespace or comments. Note: If external libraries are included in the codebase
 *   either in a checked-in virtual environment or as vendored code, that will currently
 *   be counted as user written code.
 * @kind metric
 * @tags summary
 *       lines-of-code
 * @id py/summary/lines-of-user-code
 */

import python
import semmle.python.filters.GeneratedCode

select sum(Module m |
    exists(m.getFile().getRelativePath()) and
    not m.getFile() instanceof GeneratedFile
  |
    m.getMetrics().getNumberOfLinesOfCode()
  )
