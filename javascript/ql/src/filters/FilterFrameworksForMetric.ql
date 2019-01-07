/**
 * @name Filter out framework code
 * @description Only keep results in non-framework code
 * @kind treemap
 * @id js/not-framework-file-metric-filter
 */

import FilterFrameworks
import external.MetricFilter

from MetricResult res
where nonFrameworkFile(res.getFile())
select res, res.getValue()
