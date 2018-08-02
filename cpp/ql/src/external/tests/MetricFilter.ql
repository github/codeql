/**
 * @name Metric filter
 * @description Only include results in large files (200) lines of code.
 */
import cpp
import external.MetricFilter

from MetricResult res
where res.getFile().getMetrics().getNumberOfLinesOfCode() > 200
select res, res.getValue()
