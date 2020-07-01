/**
 * @name Number of statements per function
 * @description The number of C/C++ statements per function.
 * @kind treemap
 * @id cpp/statements-per-function
 * @treemap.warnOn highValues
 * @metricType callable
 * @metricAggregate avg sum max
 * @tags maintainability
 */

import cpp

from Function f, int n
where
  strictcount(f.getEntryPoint()) = 1 and
  n = count(Stmt s | s.getEnclosingFunction() = f)
select f, n
