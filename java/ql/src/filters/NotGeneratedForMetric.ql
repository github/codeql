/**
 * @name Metric Filter: non-generated files
 * @description Only keep metric results that aren't in generated files
 * @kind treemap
 * @id java/not-generated-file-metric-filter
 */

import java
import external.MetricFilter

from MetricResult res
where not res.getFile() instanceof GeneratedFile
select res, res.getValue()
