/**
 * @name Ratio of resolvable call by points-to
 * @description The percentage of (relevant) calls that can be resolved to a callee.
 * @kind metric
 * @metricType project
 * @metricAggregate sum min max avg
 * @tags meta
 * @id py/meta/points-to-resolvable-call-ratio
 */

import python
import CallGraphQuality

select projectRoot(),
  100.0 * count(PointsToBasedCallGraph::ResolvableCall call) / count(RelevantCall call).(float)
