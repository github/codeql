/**
 * @name Filter out minified files
 * @description Only keep results from files that are not minified.
 * @kind treemap
 * @id js/not-minified-file-metric-filter
 * @metricType file
 */

import javascript
import external.MetricFilter

from MetricResult res
where not res.getFile().getATopLevel().isMinified()
select res, res.getValue()
