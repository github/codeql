/**
 * Contains predicates for converting an arbitrary graph to a set of `typeModel` rows.
 */

private import codeql.util.Location

/**
 * Concatenates two access paths, separating them by `.` unless one of them is empty.
 */
bindingset[x, y]
string join(string x, string y) {
  if x = "" or y = "" then result = x + y else result = x + "." + y
}

private module WithLocation<LocationSig Location> {
  signature class NodeSig {
    /** Gets the location of this node if it has one. */
    Location getLocation();

    /** Gets a string representation of this node. */
    string toString();
  }
}

/**
 * Specifies a graph to export in `GraphExport`.
 */
signature module GraphExportSig<LocationSig Location, WithLocation<Location>::NodeSig Node> {
  /**
   * Holds if an edge `pred -> succ` exist with the access path `path`.
   */
  bindingset[pred]
  predicate edge(Node pred, string path, Node succ);

  /**
   * Holds if `node` is exposed to downstream packages with the given `(type, path)` tuple.
   *
   * A consumer of the exported graph should be able to interpret the `(type, path)` pair
   * without having access to the current codebase.
   */
  predicate exposedName(Node node, string type, string path);

  /**
   * Holds if `name` is a good name for `node` that should be used in case the node needs
   * to be named with a type name.
   *
   * Should not hold for nodes that are named via `exposedName`.
   */
  predicate suggestedName(Node node, string name);

  /**
   * Holds if `node` must be named if it is part of the exported graph.
   */
  predicate mustBeNamed(Node node);

  /**
   * Holds if the exported graph should contain `node`, if it is reachable from an exposed node.
   *
   * This ensures that all paths leading from an exposed node to `node` will be exported.
   */
  predicate shouldContain(Node node);

  /**
   * Holds if `host` has a method that returns `this`, and `path` is the path from `host`
   * to the method followed by the appropriate `ReturnValue` token.
   *
   * For example, if the method is named `m` then `path` should be `Member[m].ReturnValue`
   * or `Method[m].ReturnValue`.
   */
  bindingset[host]
  predicate hasTypeSummary(Node host, string path);

  /**
   * Holds if paths going through `node` should be blocked.
   *
   * For example, this can be the case for functions that are public at runtime
   * but intended to be private.
   */
  predicate shouldNotContain(Node node);
}

/**
 * Module for exporting an arbitrary graph as models-as-data rows.
 */
module GraphExport<
  LocationSig Location, WithLocation<Location>::NodeSig Node, GraphExportSig<Location, Node> S>
{
  private import S

  private Node getAnExposedNode() {
    not shouldNotContain(result) and
    (
      exposedName(result, _, _)
      or
      edge(getAnExposedNode(), _, result)
    )
  }

  pragma[nomagic]
  private predicate exposedEdge(Node pred, string path, Node succ) {
    // Materialize this relation so we can access 'edge' without binding set on 'pred'
    pred = getAnExposedNode() and
    edge(pred, path, succ) and
    // Filter trivial edges at this stage (they disturb fan-in and fan-out checks)
    not (pred = succ and path = "")
  }

  private Node getARelevantNode() {
    result = getAnExposedNode() and
    shouldContain(result)
    or
    exposedEdge(result, _, getARelevantNode())
  }

  final private class FinalNode = Node;

  private class RelevantNode extends FinalNode {
    RelevantNode() { this = getARelevantNode() }
  }

  pragma[inline]
  private RelevantNode getAPredecessor(RelevantNode node, string path) {
    exposedEdge(result, path, node)
  }

  pragma[inline]
  private RelevantNode getASuccessor(RelevantNode node, string path) {
    exposedEdge(node, path, result)
  }

  private predicate hasPrettyName(RelevantNode node) {
    exposedName(node, _, "")
    or
    suggestedName(node, _)
  }

  /**
   * Holds if `node` has multiple predecessors, or one predecessor and an entry point.
   */
  private predicate hasFanIn(RelevantNode node) {
    exists(int degree | degree = strictcount(getAPredecessor(node, _)) |
      degree > 1
      or
      // Treat an entry point as an extra in-degree. This is needed to ensure all reachable cycles
      // contain at least one node with fan-in (to ensure the node is named).
      degree = 1 and
      exposedName(node, _, _)
    )
  }

  /**
   * Holds if `succ` can be merged with `pred` as there are no other ways
   * to reach it and it doesn't have a name.
   */
  private predicate unificationEdge(RelevantNode pred, RelevantNode succ) {
    exposedEdge(pred, "", succ) and
    not hasFanIn(succ) and
    not exposedName(succ, _, _) and
    not S::mustBeNamed(succ) and
    not suggestedName(succ, _)
    or
    pred = succ // ensure all nodes are assigned to an SCC
  }

  private module Unification = QlBuiltins::EquivalenceRelation<RelevantNode, unificationEdge/2>;

  pragma[nomagic]
  private Unification::EquivalenceClass getASuccessorUnified(RelevantNode node, string path) {
    result = Unification::getEquivalenceClass(getASuccessor(node, path))
  }

  /** Holds if `node` has multiple outgoing edges (after unifying equivalent successors). */
  private predicate hasFanOut(RelevantNode node) { strictcount(getASuccessorUnified(node, _)) > 1 }

  /** Holds if `node` reaches a fan-out without passing through a named node. */
  private predicate reachesFanOut(RelevantNode node) {
    not exposedName(node, _, "") and
    (
      hasFanOut(node)
      or
      // Handle the special case where a fan-in is part a cycle of nodes that all have out-degree 1.
      getUniqueSuccessorIfUnnamed+(node) = node
      or
      reachesFanOut(getASuccessor(node, _))
    )
  }

  private RelevantNode getUniqueSuccessorIfUnnamed(RelevantNode node) {
    result = getASuccessor(node, _) and
    not hasFanOut(node) and // ensures uniqueness
    not exposedName(node, _, "") and
    not S::mustBeNamed(node)
  }

  private predicate nodeMustBeNamed(RelevantNode node) {
    exposedName(node, _, "")
    or
    S::mustBeNamed(node)
    or
    hasFanIn(node) and
    reachesFanOut(node)
  }

  /** Gets a type-name to use as a prefix, in case we need to synthesize a name. */
  private string getAPrefixTypeName(RelevantNode node) {
    result =
      min(string prefix |
        exists(string type, string path |
          exposedName(node, type, path) and
          prefix = join(type, path)
        )
        or
        suggestedName(node, prefix)
      |
        prefix
      )
    or
    not hasPrettyName(node) and
    result = getAPrefixTypeName(getAPredecessor(node, _))
  }

  /**
   * Holds if a synthetic name must be generated for `node`.
   */
  private predicate isSyntheticallyNamedNode(RelevantNode node, string prefix) {
    nodeMustBeNamed(node) and
    not hasPrettyName(node) and
    prefix = min(getAPrefixTypeName(node))
  }

  /**
   * Gets a synthetic type name to generate for `node`, if it doesn't have a pretty name.
   */
  private string getSyntheticName(RelevantNode node) {
    exists(int k, string prefixTypeName |
      node =
        rank[k](RelevantNode n, string path, int startline, int startcol, int endline, int endcol |
          isSyntheticallyNamedNode(n, prefixTypeName) and
          n.getLocation().hasLocationInfo(path, startline, startcol, endline, endcol)
        |
          // Use location information for an arbitrary ordering
          // TODO: improve support for nodes without a location, currently they can cause FNs
          n order by path, startline, startcol, endline, endcol
        ) and
      result = prefixTypeName + "~expr" + k
    )
  }

  private string getNodeName(RelevantNode node) {
    nodeMustBeNamed(node) and
    (
      exposedName(node, result, "")
      or
      suggestedName(node, result) and
      not exposedName(node, _, "")
      or
      result = getSyntheticName(node)
    )
  }

  /**
   * Holds if `(type, path)` resolves to `node` in the exported graph.
   */
  predicate pathToNode(string type, string path, RelevantNode node) {
    type = getNodeName(node) and
    path = ""
    or
    exposedName(node, type, path)
    or
    not nodeMustBeNamed(node) and
    exists(string prevPath, string step |
      pathToNode(type, prevPath, getAPredecessor(node, step)) and
      path = join(prevPath, step)
    )
  }

  /**
   * Holds if `type1, type2, path` should be emitted as a type row.
   *
   * That is, `(type2, path)` leads to an value belonging to `type1`.
   */
  predicate typeModel(string type1, string type2, string path) {
    exists(string prevPath, string step, RelevantNode node |
      type1 = getNodeName(node) and
      pathToNode(type2, prevPath, getAPredecessor(node, step)) and
      path = join(prevPath, step)
    ) and
    not (type1 = type2 and path = "")
  }

  /**
   * Holds if `type, path, input, output, kind` should be emitted as a summary row.
   *
   * This is only used to emit type propagation summaries, that is, summaries of kind `type`.
   */
  predicate summaryModel(string type, string path, string input, string output, string kind) {
    exists(RelevantNode host |
      pathToNode(type, path, host) and
      hasTypeSummary(host, output) and
      input = "" and
      kind = "type"
    )
  }
}
