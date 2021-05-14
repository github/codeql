/**
 * @id rb/summary/lines-of-user-code
 * @name Lines of authored Ruby code in the database
 * @description The total number of lines of Ruby code across files, excluding library and generated code.
 * @kind metric
 * @tags summary
 */

import ruby

select sum(File f |
    f.fromSource() and
    exists(f.getRelativePath()) and
    not f.getAbsolutePath().matches("%/vendor/%")
  |
    f.getNumberOfLinesOfCode()
  )
