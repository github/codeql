/**
 * @name Sanitizers reachable from source
 * @description The number of sanitizers reachable from a recognized taint source.
 * @kind metric
 * @metricType project
 * @metricAggregate sum
 * @tags meta
 * @id js/meta/sanitizers-reachable-from-source
 */

import javascript
import meta.internal.TaintMetrics

module BasicTaintConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node = relevantTaintSource() }

  predicate isSink(DataFlow::Node node) { node = relevantSanitizerInput() }
}

module BasicTaintFlow = TaintTracking::Global<BasicTaintConfig>;

select projectRoot(), count(DataFlow::Node node | BasicTaintFlow::flowTo(node))
