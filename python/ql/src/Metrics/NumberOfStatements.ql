/**
 * @name Number of statements
 * @description The number of statements in this module
 * @kind treemap
 * @id py/number-of-statements-per-file
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 */

import python

from Module m, int n
where n = count(Stmt s | s.getEnclosingModule() = m)
select m, n order by n desc
