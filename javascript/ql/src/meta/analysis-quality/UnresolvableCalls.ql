/**
 * @name Unresolvable calls
 * @description The number of calls that could not be resolved to a target.
 * @kind metric
 * @metricType project
 * @metricAggregate sum
 * @tags meta
 * @id js/meta/unresolvable-calls
 */

import javascript
import CallGraphQuality

select projectRoot(), count(UnresolvableCall call)
