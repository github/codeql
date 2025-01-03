/**
 * Provides queries to pretty-print an Kaleidoscope abstract syntax tree as a graph.
 *
 * By default, this will print the AST for all nodes in the database. To change
 * this behavior, extend `PrintASTConfiguration` and override `shouldPrintNode`
 * to hold for only the AST nodes you wish to view.
 */

private import codeql.actions.Ast
private import codeql.Locations

/**
 * The query can extend this class to control which nodes are printed.
 */
class PrintAstConfiguration extends string {
  PrintAstConfiguration() { this = "PrintAstConfiguration" }

  /**
   * Holds if the given node should be printed.
   */
  predicate shouldPrintNode(PrintAstNode n) { any() }
}

newtype TPrintNode = TPrintRegularAstNode(AstNode n) { any() }

private predicate shouldPrintNode(PrintAstNode n) {
  any(PrintAstConfiguration config).shouldPrintNode(n)
}

/**
 * A node in the output tree.
 */
class PrintAstNode extends TPrintNode {
  /** Gets a textual representation of this node in the PrintAst output tree. */
  string toString() { none() }

  /**
   * Gets the child node with name `edgeName`. Typically this is the name of the
   * predicate used to access the child.
   */
  PrintAstNode getChild(string edgeName) { none() }

  /** Get the Location of this AST node */
  Location getLocation() { none() }

  /** Gets a child of this node. */
  final PrintAstNode getAChild() { result = this.getChild(_) }

  /** Gets the parent of this node, if any. */
  final PrintAstNode getParent() { result.getAChild() = this }

  /** Gets a value used to order this node amongst its siblings. */
  int getOrder() {
    this =
      rank[result](PrintRegularAstNode p, Location l, File f |
        l = p.getLocation() and
        f = l.getFile()
      |
        p
        order by
          f.getBaseName(), f.getAbsolutePath(), l.getStartLine(), l.getStartColumn(),
          l.getEndLine(), l.getEndColumn()
      )
  }

  /**
   * Gets the value of the property of this node, where the name of the property
   * is `key`.
   */
  final string getProperty(string key) {
    key = "semmle.label" and
    result = this.toString()
    or
    key = "semmle.order" and result = this.getOrder().toString()
  }
}

/** An `AstNode` in the output tree. */
class PrintRegularAstNode extends PrintAstNode, TPrintRegularAstNode {
  AstNode astNode;

  PrintRegularAstNode() { this = TPrintRegularAstNode(astNode) }

  override string toString() {
    result = "[" + concat(astNode.getAPrimaryQlClass(), ", ") + "] " + astNode.toString()
  }

  override Location getLocation() { result = astNode.getLocation() }

  override PrintAstNode getChild(string name) {
    exists(int i |
      name = i.toString() and
      result =
        TPrintRegularAstNode(rank[i](AstNode child, Location l |
            child.getParentNode() = astNode and
            child.getLocation() = l
          |
            child
            order by
              l.getStartLine(), l.getStartColumn(), l.getEndColumn(), l.getEndLine(),
              child.toString()
          ))
    )
  }
}

/**
 * Holds if `node` belongs to the output tree, and its property `key` has the
 * given `value`.
 */
query predicate nodes(PrintAstNode node, string key, string value) {
  value = node.getProperty(key) and shouldPrintNode(node)
}

/**
 * Holds if `target` is a child of `source` in the AST, and property `key` of
 * the edge has the given `value`.
 */
query predicate edges(PrintAstNode source, PrintAstNode target, string key, string value) {
  shouldPrintNode(source) and
  shouldPrintNode(target) and
  target = source.getChild(_) and
  (
    key = "semmle.label" and
    value = strictconcat(string name | source.getChild(name) = target | name, "/")
    or
    key = "semmle.order" and
    value = target.getProperty("semmle.order")
  )
}

/**
 * Holds if property `key` of the graph has the given `value`.
 */
query predicate graphProperties(string key, string value) {
  key = "semmle.graphKind" and value = "tree"
}
