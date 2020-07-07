/**
 * @name Resolvable calls by points-to, to relevant target
 * @description The number of (relevant) calls that could be resolved to its target that is relevant.
 * @kind metric
 * @metricType project
 * @metricAggregate sum
 * @tags meta
 * @id py/meta/points-to-resolvable-calls-relevant-target
 */

import python
import CallGraphQuality

select projectRoot(), count(PointsTo::ResolvableCallRelevantTarget call)
