/**
 * @name Tainted expressions
 * @description The number of expressions reachable from a remote flow source
 *              via default taint-tracking steps.
 * @kind metric
 * @metricType project
 * @metricAggregate sum
 * @tags meta
 * @id js/meta/tainted-nodes
 */

import javascript
import meta.internal.TaintMetrics

module BasicTaintConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node = relevantTaintSource() }

  predicate isSink(DataFlow::Node node) {
    // To reduce noise from synthetic nodes, only count value nodes
    node instanceof DataFlow::ValueNode and
    not node.getFile() instanceof IgnoredFile
  }
}

module BasicTaintFlow = TaintTracking::Global<BasicTaintConfig>;

select projectRoot(), count(DataFlow::Node node | BasicTaintFlow::flowTo(node))
