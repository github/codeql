/**
 * @name Filter: only keep results that are outside of test files
 * @description Exclude results in test files.
 * @kind treemap
 * @id cs/test-file-metric-filter
 */

import csharp
import semmle.code.csharp.frameworks.Test
import external.MetricFilter

from MetricResult res
where not res.getFile() instanceof TestFile
select res, res.getValue()
