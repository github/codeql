/**
 * @name Taint sources
 * @description The number of remote flow sources and document.location sources
 * @kind metric
 * @metricType project
 * @metricAggregate sum
 * @tags meta
 * @id js/meta/taint-sources
 */

import javascript
import meta.internal.TaintMetrics

select projectRoot(), count(relevantTaintSource())
