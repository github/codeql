/**
 * @id ql/summary/lines-of-user-code
 * @name Total Lines of user written QL code in the database
 * @description The total number of lines of QL code from the source code
 *   directory, excluding external library and auto-generated files. This
 *   query counts the lines of code, excluding whitespace or comments.
 * @kind metric
 * @tags summary
 */

import ql

select sum(File f |
    f.fromSource() and
    exists(f.getRelativePath())
  |
    f.getNumberOfLinesOfCode()
  )
