/**
 * @name Failed to include header file
 * @description A count of all failed includes, grouped by filename.
 * @kind metric
 * @tags summary telemetry
 * @id cpp/telemetry/failed-includes
 */

import Metrics

from CppMetrics::MissingIncludeCount e
select e.getIncludeText(), e.getValue() as c order by c desc
