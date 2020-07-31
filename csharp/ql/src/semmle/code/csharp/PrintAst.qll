import csharp

private newtype TPrintAstConfiguration = MkPrintAstConfiguration()

/**
 * The query can extend this class to control which elements are printed.
 */
class PrintAstConfiguration extends TPrintAstConfiguration {
  string toString() { result = "PrintAstConfiguration" }

  /**
   * Holds if the AST for `elem` should be printed. By default, holds for all
   * elements.
   */
  predicate shouldPrint(Element elem) { any() }

  predicate selectedFile(File f){ any() }
}

private predicate shouldPrint(Element elem) {
  exists(PrintAstConfiguration config | config.shouldPrint(elem))
}

private predicate selectedFile(File f) {
  exists(PrintAstConfiguration config | config.selectedFile(f))
}

private newtype TPrintAstNode =
  TAstNode(ControlFlowElement ast) { shouldPrint(ast) }
  // we might have more types.

/**
 * A node in the output tree.
 */
class PrintAstNode extends TPrintAstNode {
  /**
   * Gets a textual representation of this node in the PrintAst output tree.
   */
  abstract string toString();

  /**
   * Gets the child node at index `childIndex`. Child indices must be unique,
   * but need not be contiguous (but see `getChildByRank`).
   */
  abstract PrintAstNode getChild(int childIndex);

  final predicate shouldPrint() { any() }

  /**
   * Gets the children of this node.
   */
  final PrintAstNode getAChild() { result = getChild(_) }

  /**
   * Gets the parent of this node, if any.
   */
  final PrintAstNode getParent() { result.getAChild() = this }

  /**
   * Gets the location of this node in the source code.
   */
  abstract Location getLocation();

  /**
   * Gets the value of the property of this node, where the name of the property
   * is `key`.
   */
  string getProperty(string key) {
    key = "semmle.label" and
    result = toString()
  }

  /**
   * Gets the label for the edge from this node to the specified child. By
   * default, this is just the index of the child, but subclasses can override
   * this.
   */
  string getChildEdgeLabel(int childIndex) {
    exists(getChild(childIndex)) and
    result = childIndex.toString()
  }
}

/**
 * A node representing an AST node.
 */
abstract class BaseAstNode extends PrintAstNode {
  Element ast;

  override string toString() { 
    //result = rank[1]("[" + ast.getAQlClass().toString() + "] " + ast.toString()) 
    result = ast.toString()
  }

  final override Location getLocation() { result = ast.getLocation() and selectedFile(result.getFile()) }

  /**
   * Gets the AST represented by this node.
   */
  final Element getAst() { result = ast }
}

class AstNode extends BaseAstNode, TAstNode {
  AstNode() { this = TAstNode(ast) }

  override AstNode getChild(int childIndex) {
    result.getAst() = ast.getChild(childIndex)
  }
}

/** Holds if `node` belongs to the output tree, and its property `key` has the given `value`. */
query predicate nodes(PrintAstNode node, string key, string value) {
  node.shouldPrint() and
  value = node.getProperty(key)
}

/**
 * Holds if `target` is a child of `source` in the AST, and property `key` of the edge has the
 * given `value`.
 */
query predicate edges(PrintAstNode source, PrintAstNode target, string key, string value) {
  exists(int childIndex |
    source.shouldPrint() and
    target.shouldPrint() and
    target = source.getChild(childIndex) and
    (
      key = "semmle.label" and value = source.getChildEdgeLabel(childIndex)
      or
      key = "semmle.order" and value = childIndex.toString()
    )
  )
}

/** Holds if property `key` of the graph has the given `value`. */
query predicate graphProperties(string key, string value) {
  key = "semmle.graphKind" and value = "tree"
}