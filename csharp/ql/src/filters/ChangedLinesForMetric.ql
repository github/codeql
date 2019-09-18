/**
 * @name Filter: only keep results from source that have been changed since the base line
 * @description Exclude results that have not changed since the base line.
 * @id cs/changed-lines-metric-filter
 * @kind treemap
 */

import csharp
import external.ExternalArtifact
import external.MetricFilter
import ChangedLines

from MetricResult res
where changedLine(res.getFile(), _)
select res, res.getValue()
