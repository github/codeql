/**
 * @name API-graph points-to edges
 * @description The number of points-to edges in the API graph.
 * @kind metric
 * @metricType project
 * @metricAggregate sum
 * @tags meta
 * @id js/meta/api-graph-points-to-edges
 */

import javascript
import meta.MetaMetrics

select projectRoot(), count(API::Node pred, API::Node succ | pred.refersTo(succ))
