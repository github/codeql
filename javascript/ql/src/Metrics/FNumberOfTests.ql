/**
 * @name Number of tests
 * @description The number of tests defined in a file.
 * @kind treemap
 * @treemap.warnOn lowValues
 * @metricType file
 * @metricAggregate avg sum max
 * @precision medium
 * @id js/test-in-files
 */

import semmle.javascript.frameworks.Testing

from File f, int n
where n = strictcount(Test test | test.getFile() = f)
select f, n order by n desc
