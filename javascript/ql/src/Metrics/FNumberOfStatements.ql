/**
 * @name Number of statements in files
 * @description The number of statements in a file.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @precision very-high
 * @id js/statements-per-file
 */

import javascript

from File f, int n
where n = count(Stmt s | s.getTopLevel().getFile() = f)
select f, n order by n desc
