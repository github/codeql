/**
 * @name Successfully extracted lines
 * @description Count all lines in source code in which something was extracted. Entities spanning multiple lines like multi-line strings or comments only contribute one line to this count.
 * @kind metric
 * @id swift/diagnostics/successfully-extracted-lines
 * @tags summary
 *       debug
 */

import swift

select sum(File f | | f.getNumberOfLinesOfCode())
