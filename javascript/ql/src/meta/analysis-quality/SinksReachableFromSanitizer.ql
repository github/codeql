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
import meta.internal.TaintMetrics

module BasicTaintConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node = relevantSanitizerOutput() }

  predicate isSink(DataFlow::Node node) { node = relevantTaintSink() }
}

module BasicTaintFlow = TaintTracking::Global<BasicTaintConfig>;

select projectRoot(), count(DataFlow::Node node | BasicTaintFlow::flowTo(node))
