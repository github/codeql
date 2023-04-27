/**
 * @name Successfully extracted lines
 * @description Count all lines in source code in which something was extracted. Entities spanning multiple lines like multi-line strings or comments only contribute one line to this count.
 * @kind metric
 * @id swift/diagnostics/successfully-extracted-lines
 * @tags summary
 */

import swift

select count(File f, int line |
    exists(Location loc |
      not loc instanceof UnknownLocation and loc.getFile() = f and loc.getStartLine() = line
    )
  )
