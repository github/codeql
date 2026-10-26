/**
 * @name API-graph nodes
 * @description The number of nodes in the API graph.
 * @kind metric
 * @metricType project
 * @metricAggregate sum
 * @tags meta
 * @id js/meta/api-graph-nodes
 */

import javascript
import meta.MetaMetrics

select projectRoot(), count(API::Node nd)
