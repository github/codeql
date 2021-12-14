/**
 * @name Resolvable calls
 * @description The number of calls that could be resolved to its target.
 * @kind metric
 * @metricType project
 * @metricAggregate sum
 * @tags meta
 * @id js/meta/resolvable-calls
 */

import javascript
import CallGraphQuality

select projectRoot(), count(ResolvableCall call)
