/**
 * @name API-graph edges
 * @description The number of edges (other than points-to edges) in the API graph.
 * @kind metric
 * @metricType project
 * @metricAggregate sum
 * @tags meta
 * @id js/meta/api-graph-edges
 */

import javascript
import meta.MetaMetrics

select projectRoot(),
  count(API::Node pred, API::Label::ApiLabel lbl, API::Node succ | succ = pred.getASuccessor(lbl))
