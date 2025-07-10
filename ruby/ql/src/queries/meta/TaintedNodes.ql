/**
 * @name Tainted nodes
 * @description Nodes reachable from a remote flow source via default taint-tracking steps.
 * @kind problem
 * @problem.severity recommendation
 * @id rb/meta/tainted-nodes
 * @tags meta
 * @precision very-low
 */

import internal.TaintMetrics
import codeql.ruby.DataFlow
import codeql.ruby.TaintTracking

private module BasicTaintConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node = relevantTaintSource(_) }

  predicate isSink(DataFlow::Node node) {
    // To reduce noise from synthetic nodes, only count nodes that have an associated expression.
    exists(node.asExpr().getExpr())
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

private module BasicTaintFlow = TaintTracking::Global<BasicTaintConfig>;

from DataFlow::Node node
where BasicTaintFlow::flow(_, node)
select node, "Tainted node"
