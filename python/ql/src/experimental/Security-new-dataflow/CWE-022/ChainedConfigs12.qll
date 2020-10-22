/**
 * This defines a `PathGraph` where sinks from `TaintTracking::Configuration`s are identified with
 * sources from `TaintTracking2::Configuration`s if they represent the same `ControlFlowNode`.
 *
 * Paths are then connected appropriately.
 */

import python
import experimental.dataflow.DataFlow
import experimental.dataflow.DataFlow2
import experimental.dataflow.TaintTracking
import experimental.dataflow.TaintTracking2

/**
 * A `ControlFlowNode` that appears as a sink in Config1 and a source in Config2.
 */
private predicate crossoverNode(ControlFlowNode n) {
  exists(DataFlow::Node n1, DataFlow2::Node n2 |
    any(TaintTracking::Configuration t1).isSink(n1) and
    any(TaintTracking2::Configuration t2).isSource(n2) and
    n = n1.asCfgNode() and
    n = n2.asCfgNode()
  )
}

/**
 * A new type which represents the union of the two sets of nodes.
 */
private newtype TCustomPathNode =
  Config1Node(DataFlow::PathNode node1) { not crossoverNode(node1.getNode().asCfgNode()) } or
  Config2Node(DataFlow2::PathNode node1) { not crossoverNode(node1.getNode().asCfgNode()) } or
  CrossoverNode(ControlFlowNode e) { crossoverNode(e) }

/**
 * A class representing the set of all the path nodes in either config.
 */
class CustomPathNode extends TCustomPathNode {
  /** Gets the PathNode if it is in Config1. */
  DataFlow::PathNode asNode1() {
    this = Config1Node(result) or this = CrossoverNode(result.getNode().asCfgNode())
  }

  /** Gets the PathNode if it is in Config2. */
  DataFlow2::PathNode asNode2() {
    this = Config2Node(result) or this = CrossoverNode(result.getNode().asCfgNode())
  }

  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    asNode1().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    or
    asNode2().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

  string toString() {
    result = asNode1().toString()
    or
    result = asNode2().toString()
  }
}

/** Holds if `(a,b)` is an edge in the graph of data flow path explanations. */
query predicate edges(CustomPathNode a, CustomPathNode b) {
  // Edge is in Config1 graph
  DataFlow::PathGraph::edges(a.asNode1(), b.asNode1())
  or
  // Edge is in Config2 graph
  DataFlow2::PathGraph::edges(a.asNode2(), b.asNode2())
}

/** Holds if `n` is a node in the graph of data flow path explanations. */
query predicate nodes(CustomPathNode n, string key, string val) {
  // Node is in Config1 graph
  DataFlow::PathGraph::nodes(n.asNode1(), key, val)
  or
  // Node is in Config2 graph
  DataFlow2::PathGraph::nodes(n.asNode2(), key, val)
}
