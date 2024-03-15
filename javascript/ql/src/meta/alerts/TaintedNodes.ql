/**
 * @name Tainted expressions
 * @description The number of expressions reachable from a remote flow source
 *              via default taint-tracking steps.
 * @kind problem
 * @problem.severity recommendation
 * @tags meta
 * @id js/meta/alerts/tainted-nodes
 * @precision very-low
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

// Avoid linking to the source as this would upset the statistics: nodes reachable
// from multiple sources would be counted multiple times, and that's not what we intend to measure.
from DataFlow::Node node
where BasicTaintFlow::flowTo(node)
select node, "Tainted node"
