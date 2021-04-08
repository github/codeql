/**
 * @name Sinks reachable from sanitizer
 * @description The number of sinks reachable from a recognized sanitizer call.
 * @kind metric
 * @metricType project
 * @metricAggregate sum
 * @tags meta
 * @id js/meta/sinks-reachable-from-sanitizer
 */

import javascript
import TaintMetrics

class BasicTaintConfiguration extends TaintTracking::Configuration {
  BasicTaintConfiguration() { this = "BasicTaintConfiguration" }

  override predicate isSource(DataFlow::Node node) { node = relevantSanitizerOutput() }

  override predicate isSink(DataFlow::Node node) { node = relevantTaintSink() }
}

select projectRoot(), count(DataFlow::Node node | any(BasicTaintConfiguration cfg).hasFlow(_, node))
