/**
 * @name API-graph right-hand-side nodes
 * @description The number of data-flow nodes corresponding to a right-hand side of
 *              a definition of an API-graph node.
 * @kind metric
 * @metricType project
 * @metricAggregate sum
 * @tags meta
 * @id js/meta/api-graph-rhs-nodes
 */

import javascript
import meta.MetaMetrics

select projectRoot(), count(any(API::Node nd).getARhs())
