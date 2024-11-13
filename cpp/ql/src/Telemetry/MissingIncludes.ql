/**
 * @name Failed to include header file
 * @description A count of all failed includes, grouped by filename.
 * @kind metric
 * @tags summary telemetry
 * @id cpp/telemetry/failed-includes
 */

import Metrics

from CppMetrics::MissingIncludeCount e
where RankMetric<CppMetrics::MissingIncludeCount>::getRank(e) <= 50
select e.getIncludeText(), e.getValue()
