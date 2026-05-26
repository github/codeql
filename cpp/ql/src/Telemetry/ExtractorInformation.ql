/**
 * @name C/C++ extraction information
 * @description Information about the extraction for a C/C++ database
 * @kind metric
 * @tags summary telemetry
 * @id cpp/telemetry/extraction-information
 */

import cpp
import DatabaseQuality

from string key, float value
where
  (
    CallTargetStatsReport::numberOfOk(key, value) or
    CallTargetStatsReport::numberOfNotOk(key, value) or
    CallTargetStatsReport::percentageOfOk(key, value) or
    ExprTypeStatsReport::numberOfOk(key, value) or
    ExprTypeStatsReport::numberOfNotOk(key, value) or
    ExprTypeStatsReport::percentageOfOk(key, value)
  ) and
  /* Infinity */
  value != 1.0 / 0.0 and
  /* -Infinity */
  value != -1.0 / 0.0 and
  /* NaN */
  value != 0.0 / 0.0
select key, value
