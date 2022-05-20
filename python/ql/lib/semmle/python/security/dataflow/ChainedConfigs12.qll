/**
 * DEPRECATED -- use flow state instead
 *
 * This defines a `PathGraph` where sinks from `TaintTracking::Configuration`s are identified with
 * sources from `TaintTracking2::Configuration`s if they represent the same `ControlFlowNode`.
 *
 * Paths are then connected appropriately.
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.DataFlow2
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.TaintTracking2

/**
 * A `DataFlow::Node` that appears as a sink in Config1 and a source in Config2.
 */
private predicate crossoverNode(DataFlow::Node n) {
  any(TaintTracking::Configuration t1).isSink(n) and
  any(TaintTracking2::Configuration t2).isSource(n)
}

/**
 * A new type which represents the union of the two sets of nodes.
 */
private newtype TCustomPathNode =
  Config1Node(DataFlow::PathNode node1) { not crossoverNode(node1.getNode()) } or
  Config2Node(DataFlow2::PathNode node2) { not crossoverNode(node2.getNode()) } or
  CrossoverNode(DataFlow::Node node) { crossoverNode(node) }

/**
 * DEPRECATED: Use flow state instead
 *
 * A class representing the set of all the path nodes in either config.
 */
deprecated class CustomPathNode extends TCustomPathNode {
  /** Gets the PathNode if it is in Config1. */
  DataFlow::PathNode asNode1() {
    this = Config1Node(result) or this = CrossoverNode(result.getNode())
  }

  /** Gets the PathNode if it is in Config2. */
  DataFlow2::PathNode asNode2() {
    this = Config2Node(result) or this = CrossoverNode(result.getNode())
  }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    asNode1().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    or
    asNode2().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

  /** Gets a textual representation of this element. */
  string toString() {
    result = asNode1().toString()
    or
    result = asNode2().toString()
  }
}

/**
 * DEPRECATED: Use flow state instead
 *
 * Holds if `(a,b)` is an edge in the graph of data flow path explanations.
 */
deprecated query predicate edges(CustomPathNode a, CustomPathNode b) {
  // Edge is in Config1 graph
  DataFlow::PathGraph::edges(a.asNode1(), b.asNode1())
  or
  // Edge is in Config2 graph
  DataFlow2::PathGraph::edges(a.asNode2(), b.asNode2())
}

/**
 * DEPRECATED: Use flow state instead
 *
 * Holds if `n` is a node in the graph of data flow path explanations.
 */
deprecated query predicate nodes(CustomPathNode n, string key, string val) {
  // Node is in Config1 graph
  DataFlow::PathGraph::nodes(n.asNode1(), key, val)
  or
  // Node is in Config2 graph
  DataFlow2::PathGraph::nodes(n.asNode2(), key, val)
}
