/**
 * @name Metric filter
 * @description Only include results in large files (200) lines of code.
 * @kind treemap
 * @deprecated
 */

import csharp
import external.MetricFilter

from MetricResult res
where res.getFile().getNumberOfLinesOfCode() > 200
select res, res.getValue()
