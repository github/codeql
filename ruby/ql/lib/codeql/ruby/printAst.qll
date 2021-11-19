/**
 * Provides queries to pretty-print a Ruby abstract syntax tree as a graph.
 *
 * By default, this will print the AST for all nodes in the database. To change
 * this behavior, extend `PrintASTConfiguration` and override `shouldPrintNode`
 * to hold for only the AST nodes you wish to view.
 */

private import AST
private import codeql.ruby.security.performance.RegExpTreeView as RETV

/** Holds if `n` appears in the desugaring of some other node. */
predicate isDesugared(AstNode n) {
  n = any(AstNode sugar).getDesugared()
  or
  isDesugared(n.getParent())
}

/**
 * The query can extend this class to control which nodes are printed.
 */
class PrintAstConfiguration extends string {
  PrintAstConfiguration() { this = "PrintAstConfiguration" }

  /**
   * Holds if the given node should be printed.
   */
  predicate shouldPrintNode(AstNode n) {
    not isDesugared(n)
    or
    not n.isSynthesized()
    or
    n.isSynthesized() and
    not n = any(AstNode sugar).getDesugared() and
    exists(AstNode parent |
      parent = n.getParent() and
      not parent.isSynthesized() and
      not n = parent.getDesugared()
    )
  }

  predicate shouldPrintAstEdge(AstNode parent, string edgeName, AstNode child) {
    child = parent.getAChild(edgeName) and
    not child = parent.getDesugared()
  }
}

private predicate shouldPrintNode(AstNode n) {
  any(PrintAstConfiguration config).shouldPrintNode(n)
}

private predicate shouldPrintAstEdge(AstNode parent, string edgeName, AstNode child) {
  any(PrintAstConfiguration config).shouldPrintAstEdge(parent, edgeName, child)
}

newtype TPrintNode =
  TPrintRegularAstNode(AstNode n) { shouldPrintNode(n) } or
  TPrintRegExpNode(RETV::RegExpTerm term) {
    exists(RegExpLiteral literal |
      shouldPrintNode(literal) and
      term.getRootTerm() = literal.getParsed()
    )
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

  /** Gets a child of this node. */
  final PrintAstNode getAChild() { result = this.getChild(_) }

  /** Gets the parent of this node, if any. */
  final PrintAstNode getParent() { result.getAChild() = this }

  /**
   * Holds if this node is at the specified location. The location spans column
   * `startcolumn` of line `startline` to column `endcolumn` of line `endline`
   * in file `filepath`. For more information, see
   * [LGTM locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    none()
  }

  /** Gets a value used to order this node amongst its siblings. */
  int getOrder() { none() }

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

  override PrintAstNode getChild(string edgeName) {
    exists(AstNode child | shouldPrintAstEdge(astNode, edgeName, child) |
      result = TPrintRegularAstNode(child)
    )
    or
    // If this AST node is a regexp literal, add the parsed regexp tree as a
    // child.
    exists(RETV::RegExpTerm t | t = astNode.(RegExpLiteral).getParsed() |
      result = TPrintRegExpNode(t) and edgeName = "getParsed"
    )
  }

  override int getOrder() {
    this =
      rank[result](PrintRegularAstNode p, Location l, File f |
        l = p.getLocation() and
        f = l.getFile()
      |
        p order by f.getBaseName(), f.getAbsolutePath(), l.getStartLine(), l.getStartColumn()
      )
  }

  /** Gets the location of this node. */
  Location getLocation() { result = astNode.getLocation() }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    astNode.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

/** A parsed regexp node in the output tree. */
class PrintRegExpNode extends PrintAstNode, TPrintRegExpNode {
  RETV::RegExpTerm regexNode;

  PrintRegExpNode() { this = TPrintRegExpNode(regexNode) }

  override string toString() {
    result = "[" + concat(regexNode.getAPrimaryQlClass(), ", ") + "] " + regexNode.toString()
  }

  override PrintAstNode getChild(string edgeName) {
    // Use the child index as an edge name.
    exists(int i | result = TPrintRegExpNode(regexNode.getChild(i)) and edgeName = i.toString())
  }

  override int getOrder() { exists(RETV::RegExpTerm p | p.getChild(result) = regexNode) }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    regexNode.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

/**
 * Holds if `node` belongs to the output tree, and its property `key` has the
 * given `value`.
 */
query predicate nodes(PrintAstNode node, string key, string value) { value = node.getProperty(key) }

/**
 * Holds if `target` is a child of `source` in the AST, and property `key` of
 * the edge has the given `value`.
 */
query predicate edges(PrintAstNode source, PrintAstNode target, string key, string value) {
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
