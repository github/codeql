/**
 * @name Number of interfaces
 * @description The number of interfaces in a compilation unit.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @id java/interfaces-per-file
 * @tags maintainability
 */

import java

from CompilationUnit f, int n
where n = count(Interface i | i.fromSource() and i.getCompilationUnit() = f)
select f, n order by n desc
