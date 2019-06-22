/**
 * @name Resolved calls
 * @description The number of calls that could be resolved to its target.
 * @kind metric
 * @metricType project
 * @metricAggregate sum
 * @tags meta
 * @id js/meta/resolved-calls
 */
import javascript
import CallGraphQuality

select projectRoot(), count(ResolvedCall call)
