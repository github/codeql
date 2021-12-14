/**
 * @name Number of classes
 * @description The number of classes in a compilation unit.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @id java/classes-per-file
 * @tags maintainability
 */

import java

from CompilationUnit f, int n
where n = count(Class c | c.fromSource() and c.getCompilationUnit() = f)
select f, n order by n desc
