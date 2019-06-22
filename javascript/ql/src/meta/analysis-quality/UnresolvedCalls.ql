/**
 * @name Unresolved calls
 * @description The number of calls that could not be resolved to its target.
 * @kind metric
 * @metricType project
 * @metricAggregate sum
 * @tags meta
 * @id js/meta/unresolved-calls
 */
import javascript
import CallGraphQuality

select projectRoot(), count(UnresolvedCall call)
