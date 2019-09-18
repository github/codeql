/**
 * @name Filter: only keep results from source that have not changed since the base line
 * @description Complement of ChangedLinesForMetric.ql.
 * @kind treemap
 * @id cs/unchanged-lines-metric-filter
 */

import csharp
import external.ExternalArtifact
import external.MetricFilter
import ChangedLines

from MetricResult res
where not changedLine(res.getFile(), _)
select res, res.getValue()
