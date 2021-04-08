/**
 * @name Taint sinks
 * @description The number of high-severity taint sinks.
 * @kind metric
 * @metricType project
 * @metricAggregate sum
 * @tags meta
 * @id js/meta/taint-sinks
 */

import javascript
import TaintMetrics

select projectRoot(), count(relevantTaintSink())
