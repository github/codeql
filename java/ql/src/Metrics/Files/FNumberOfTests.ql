/**
 * @name Number of tests
 * @description The number of test methods defined in a compilation unit.
 * @kind treemap
 * @treemap.warnOn lowValues
 * @metricType file
 * @metricAggregate avg sum max
 * @id java/tests-in-files
 * @tags maintainability
 */

import java

from CompilationUnit f, int n
where n = strictcount(TestMethod test | test.fromSource() and test.getCompilationUnit() = f)
select f, n order by n desc
