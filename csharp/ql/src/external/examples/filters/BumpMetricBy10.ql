/**
 * @name Edit the value of a metric
 * @description Add 10 to a metric's value
 * @deprecated
 */

import csharp
import external.MetricFilter

from MetricResult res
select res, res.getValue() + 10
