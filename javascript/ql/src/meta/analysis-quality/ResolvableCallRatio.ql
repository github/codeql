/**
 * @name Resolvable call ratio
 * @description The percentage of non-external calls that can be resolved to a target.
 * @kind metric
 * @metricType project
 * @metricAggregate sum min max avg
 * @tags meta
 * @id js/meta/resolvable-call-ratio
 */

import javascript
import CallGraphQuality

select projectRoot(), 100.0 * count(ResolvableCall call) / count(RelevantInvoke call).(float)
