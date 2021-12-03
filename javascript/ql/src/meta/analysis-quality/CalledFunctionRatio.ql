/**
 * @name Called function ratio
 * @description The percentage of relevant functions for which a call site was found.
 * @kind metric
 * @metricType project
 * @metricAggregate sum min max avg
 * @tags meta
 * @id js/meta/called-function-ratio
 */

import javascript
import CallGraphQuality

select projectRoot(), 100.0 * count(FunctionWithCallers f) / count(RelevantFunction f).(float)
