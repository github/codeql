/**
 * @name Resolvable calls by points-to, to relevant callee
 * @description The number of (relevant) calls that could be resolved to a callee that is relevant.
 * @kind metric
 * @metricType project
 * @metricAggregate sum
 * @tags meta
 * @id py/meta/points-to-resolvable-calls-relevant-callee
 */

import python
import CallGraphQuality

select projectRoot(), count(PointsToBasedCallGraph::ResolvableCallRelevantTarget call)
