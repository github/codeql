/**
 * @name Number of tests
 * @description The number of test methods defined in a file.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @id cs/tests-in-files
 * @tags maintainability
 */

import csharp
import semmle.code.csharp.frameworks.Test

from SourceFile f, int n
where n = strictcount(TestMethod test | test.fromSource() and test.getFile() = f)
select f, n order by n desc
