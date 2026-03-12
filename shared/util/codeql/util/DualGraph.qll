/**
 * Provides an efficient mechanism for checking if two nodes have
 * a common ancestor in a graph.
 */
overlay[local?]
module;

private import Location

signature module DualGraphInputSig<LocationSig Location> {
  class Node {
    string toString();

    Location getLocation();
  }

  predicate edge(Node node1, Node node2);
}

/**
 * Creates a "dual graph" in which each node in the given graph has a "forward" and "backward"
 * copy.
 *
 * All original edges are present in both copies, but reversed in the backward copy.
 *
 * In addition, all nodes have an edge from their backward node to their forward node.
 *
 * This can be used to check if two nodes have a common ancestor in the graph, by checking
 * if a path exists from the reverse node of one node, to the forward node of another.
 */
module MakeDualGraph<LocationSig Location, DualGraphInputSig<Location> Input> {
  private import Input

  private newtype TDualNode =
    TForward(Node n) or
    TBackward(Node n)

  /** A forward or backward copy of a node from the original graph. */
  class DualNode extends TDualNode {
    /** Gets the underlying node if this is a forward node. */
    Node asForward() { this = TForward(result) }

    /** Gets the underlying node if this is a backward node. */
    Node asBackward() { this = TBackward(result) }

    /** Gets a string representation of this node. */
    string toString() {
      result = this.asForward().toString()
      or
      result = "[rev] " + this.asBackward().toString()
    }

    /** Gets the location of this node. */
    Location getLocation() {
      result = this.asForward().getLocation()
      or
      result = this.asBackward().getLocation()
    }
  }

  /** Gets the node representing the backward node wrapping `n`. */
  DualNode getBackwardNode(Node n) { result.asBackward() = n }

  /** Gets the node representing the forward node wrapping `n`. */
  DualNode getForwardNode(Node n) { result.asForward() = n }

  /**
   * Holds if the dual graph contains the edge `node1 -> node2`. See `MakeDualGraph`.
   */
  predicate dualEdge(DualNode node1, DualNode node2) {
    edge(node1.asForward(), node2.asForward())
    or
    edge(node2.asBackward(), node1.asBackward())
    or
    node1.asBackward() = node2.asForward()
  }

  /**
   * Holds if there is a non-empty path from `node1 -> node2` in the dual graph.
   */
  cached
  predicate dualPath(DualNode node1, DualNode node2) = fastTC(dualEdge/2)(node1, node2)

  /**
   * Holds if `node1` and `node2` have a common ancestor in the original graph, that is,
   * there exists a node from which both nodes are reachable.
   */
  pragma[inline]
  predicate hasCommonAncestor(Node node1, Node node2) {
    // Note: `fastTC` only checks for non-empty paths, but there is no need to special-case
    // `node1 = node2` because the path `Backward(n) -> Forward(n)` is non-empty.
    dualPath(getBackwardNode(node1), getForwardNode(node2))
  }
}
