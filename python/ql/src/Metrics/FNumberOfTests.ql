/**
 * @name Number of tests
 * @description The number of test methods defined in a module
 * @kind treemap
 * @treemap.warnOn lowValues
 * @metricType file
 * @metricAggregate avg sum max
 * @precision medium
 * @id py/tests-in-files
 */

import python
import semmle.python.filters.Tests

from Module m, int n
where n = strictcount(Test test | test.getEnclosingModule() = m)
select m.getFile(), n order by n desc
