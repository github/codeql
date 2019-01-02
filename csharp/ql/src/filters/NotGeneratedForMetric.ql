/**
 * @name Filter: only keep metric results in non-generated files
 * @description Exclude results that come from generated code.
 * @kind treemap
 * @id cs/not-generated-file-metric-filter
 */

import semmle.code.csharp.commons.GeneratedCode
import external.MetricFilter

from MetricResult res
where not isGeneratedCode(res.getFile())
select res, res.getValue()
