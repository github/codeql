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

class BasicTaintConfiguration extends TaintTracking::Configuration {
  BasicTaintConfiguration() { this = "BasicTaintConfiguration" }

  override predicate isSource(DataFlow::Node node) { node = relevantTaintSource() }

  override predicate isSink(DataFlow::Node node) { node = relevantSanitizerInput() }
}

select projectRoot(), count(DataFlow::Node node | any(BasicTaintConfiguration cfg).hasFlow(_, node))
