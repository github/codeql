/**
 * Contains predicates for converting an arbitrary graph to a set of `typeModel` rows.
 */

/**
 * Specifies a graph to export in `GraphExport`.
 */
signature module GraphExportSig {
  /** The type of node in the graph to export, usually set to `API::Node`. */
  class Node {
    /**
     * Holds if this node is located in file `path` between line `startline`, column `startcol`,
     * and line `endline`, column `endcol`.
     */
    predicate hasLocationInfo(string path, int startline, int startcol, int endline, int endcol);
  }

  /**
   * Holds if an edge `pred -> succ` exist with the access path `path`.
   */
  bindingset[pred]
  predicate edge(Node pred, string path, Node succ);

  /**
   * Gets a node to associate with the given `(type, path)` tuple.
   *
   * A consumer of the exported graph should be able to interpret the `(type, path)` pair
   * without having access to the current codebase.
   */
  Node getNodeFromName(string type, string path);

  /**
   * Holds if the exported graph should contain `node`, if it is publicly accessible.
   *
   * This ensures that all paths leading from a directly accessible node to `node` will be exported.
   */
  predicate shouldContain(Node node);

  /**
   * Holds if paths going through `node` should be blocked.
   *
   * For example, this can be the case for functions that are public at runtime
   * but intended to be private.
   */
  default predicate shouldNotContain(Node node) { none() }
}

/**
 * Module for exporting an arbitrary graph as models-as-data rows.
 */
module GraphExport<GraphExportSig S> {
  private import S

  private Node getAnExportedNode() {
    not shouldNotContain(result) and
    (
      result = getNodeFromName(_, _)
      or
      edge(getAnExportedNode(), _, result)
    )
  }

  /**
   * Gets a predecessor of `node`, labelled with the given access path.
   */
  pragma[nomagic]
  private Node getAPredecessor(Node node, string path) {
    result = getAnExportedNode() and
    edge(result, path, node)
  }

  private Node getARelevantNode() {
    result = getAnExportedNode() and
    (
      shouldContain(result)
      or
      result = getAPredecessor(getARelevantNode(), _)
    )
  }

  private string getAPredecessorTypeName(Node node) {
    node = getARelevantNode() and
    (
      result = min(string p | node = getNodeFromName(p, _) | p)
      or
      not node = getNodeFromName(_, _) and
      result = getAPredecessorTypeName(getAPredecessor(node, _))
    )
  }

  /**
   * Holds if a named type exists or will be generated for `node`.
   */
  private predicate isNamedNode(Node node, string typeName) {
    node = getARelevantNode() and
    (
      node = getNodeFromName(typeName, _)
      or
      strictcount(Node succ | edge(node, _, succ) and succ = getARelevantNode()) > 1 and
      typeName = min(getAPredecessorTypeName(node))
    )
  }

  /**
   * Gets a synthetic type name to generate for `node`.
   */
  private string getSyntheticName(Node node) {
    exists(int k, string typeName |
      node =
        rank[k](Node n, string path, int startline, int startcol, int endline, int endcol |
          isNamedNode(n, typeName) and
          not n = getNodeFromName(_, _) and
          n.hasLocationInfo(path, startline, startcol, endline, endcol)
        |
          // Use location information for an arbitrary ordering
          n order by path, startline, startcol, endline, endcol
        ) and
      result = typeName + "~expr" + k
    )
  }

  /**
   * Gets the node accessible from other codebases as `(type, path)`, including those
   * with synthesized names.
   */
  private Node getNodeFromNameEx(string type, string path) {
    result = getNodeFromName(type, path)
    or
    type = getSyntheticName(result) and path = ""
  }

  bindingset[x, y]
  private string join(string x, string y) {
    if x = "" or y = "" then result = x + y else result = x + "." + y
  }

  /**
   * Holds if `(type, path)` resolves to `node` in the exported graph.
   */
  predicate pathToNode(string type, string path, Node node) {
    node = getNodeFromNameEx(type, path)
    or
    not node = getNodeFromNameEx(_, _) and
    node = getARelevantNode() and
    exists(string label, string midPath |
      pathToNode(type, midPath, getAPredecessor(node, label)) and
      path = join(midPath, label)
    )
  }

  /**
   * Holds if `type1, type2, path` should be emitted as a type row.
   *
   * That is, `(type2, path)` leads to an value belonging to `type1`.
   */
  predicate typeModel(string type1, string type2, string path) {
    exists(string label, string midPath, Node node |
      node = getNodeFromNameEx(type1, "") and
      pathToNode(type2, midPath, getAPredecessor(node, label)) and
      path = join(midPath, label)
    )
  }
}
