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

class BasicTaintConfiguration extends TaintTracking::Configuration {
  BasicTaintConfiguration() { this = "BasicTaintConfiguration" }

  override predicate isSource(DataFlow::Node node) { node = relevantTaintSource(_) }

  override predicate isSink(DataFlow::Node node) {
    // To reduce noise from synthetic nodes, only count nodes that have an associated expression.
    exists(node.asExpr().getExpr())
  }
}

from DataFlow::Node node
where any(BasicTaintConfiguration cfg).hasFlow(_, node)
select node, "Tainted node"
