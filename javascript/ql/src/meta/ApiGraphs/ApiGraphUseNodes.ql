/**
 * @name API-graph use nodes
 * @description The number of data-flow nodes corresponding to a use of an API-graph node.
 * @kind metric
 * @metricType project
 * @metricAggregate sum
 * @tags meta
 * @id js/meta/api-graph-use-nodes
 */

import javascript
import meta.MetaMetrics

select projectRoot(), count(any(API::Node nd).getAUse())
