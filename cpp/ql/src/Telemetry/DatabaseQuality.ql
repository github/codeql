/**
 * @name Database quality
 * @description Metrics that indicate the quality of the database.
 * @kind metric
 * @tags summary telemetry
 * @id cpp/telemetry/database-quality
 */

import Metrics

from QualityMetric m
select m, m.getValue() order by m
