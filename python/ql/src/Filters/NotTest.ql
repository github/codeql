/**
 * @name Filter: non-test files
 * @description Only keep results that aren't in tests
 * @kind problem
 * @id py/not-test-file-filter
 */

import python
import external.DefectFilter
import semmle.python.filters.Tests

from DefectResult res
where not exists(TestScope s | contains(s.getLocation(), res))
select res, res.getMessage()
