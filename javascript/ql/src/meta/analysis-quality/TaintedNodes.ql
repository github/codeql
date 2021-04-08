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
import TaintMetrics

class BasicTaintConfiguration extends TaintTracking::Configuration {
  BasicTaintConfiguration() { this = "BasicTaintConfiguration" }

  override predicate isSource(DataFlow::Node node) { node = relevantTaintSource() }

  override predicate isSink(DataFlow::Node node) {
    // To reduce noise from synthetic nodes, only count value nodes
    node instanceof DataFlow::ValueNode and
    not node.getFile() instanceof IgnoredFile
  }
}

select projectRoot(), count(DataFlow::Node node | any(BasicTaintConfiguration cfg).hasFlow(_, node))
