/**
 * Provides queries to pretty-print a Go AST as a graph.
 */

import go

/**
 * Hook to customize the files and functions printed by this module.
 *
 * For an AstNode to be printed, it always requires `shouldPrintFile(f)` to hold
 * for its containing file `f`, and additionally requires `shouldPrintFunction(fun)`
 * to hold if it is, or is a child of, function `fun`.
 */
class PrintAstConfiguration extends string {
  /**
   * Restrict to a single string, making this a singleton type.
   */
  PrintAstConfiguration() { this = "PrintAstConfiguration" }

  /**
   * Holds if the AST for `func` should be printed. By default, holds for all
   * functions.
   */
  predicate shouldPrintFunction(FuncDecl func) { any() }

  /**
   * Holds if the AST for `file` should be printed. By default, holds for all
   * files.
   */
  predicate shouldPrintFile(File file) { any() }

  /**
   * Holds if the AST for `file` should include comments. By default, holds for all
   * files.
   */
  predicate shouldPrintComments(File file) { any() }
}

private predicate shouldPrintFunction(FuncDef func) {
  exists(PrintAstConfiguration config | config.shouldPrintFunction(func))
}

private predicate shouldPrintFile(File file) {
  exists(PrintAstConfiguration config | config.shouldPrintFile(file))
}

private predicate shouldPrintComments(File file) {
  exists(PrintAstConfiguration config | config.shouldPrintComments(file))
}

private FuncDecl getEnclosingFunctionDecl(AstNode n) { result = n.getParent*() }

/**
 * An AST node that should be printed.
 */
private newtype TPrintAstNode =
  TAstNode(AstNode ast) {
    shouldPrintFile(ast.getFile()) and
    // Do print ast nodes without an enclosing function, e.g. file headers, that are not otherwise excluded
    forall(FuncDecl f | f = getEnclosingFunctionDecl(ast) | shouldPrintFunction(f)) and
    (
      shouldPrintComments(ast.getFile())
      or
      not ast instanceof Comment and not ast instanceof CommentGroup
    )
  }

/**
 * A node in the output tree.
 */
class PrintAstNode extends TPrintAstNode {
  /**
   * Gets a textual representation of this node.
   */
  abstract string toString();

  /**
   * Gets the child node at index `childIndex`. Child indices must be unique,
   * but need not be contiguous.
   */
  abstract PrintAstNode getChild(int childIndex);

  /**
   * Holds if this node should be printed in the output. By default, all nodes
   * within a function are printed, but the query can override
   * `PrintAstConfiguration.shouldPrintFunction` to filter the output.
   */
  predicate shouldPrint() { exists(getLocation()) }

  /**
   * Gets a child of this node.
   */
  PrintAstNode getAChild() { result = getChild(_) }

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

  /**
   * Gets the `FuncDef` that contains this node.
   */
  abstract FuncDef getEnclosingFunction();
}

/**
 * Gets a pretty-printed representation of the QL class(es) for entity `el`.
 */
private string qlClass(AstNode el) {
  // This version shows all non-overridden QL classes:
  // result = "[" + concat(el.getAQlClass(), ", ") + "] "
  // Normally we prefer to show just the canonical class:
  result = "[" + concat(el.getAPrimaryQlClass(), ", ") + "] "
}

/**
 * A graph node representing a real AST node.
 */
class BaseAstNode extends PrintAstNode, TAstNode {
  AstNode ast;

  BaseAstNode() { this = TAstNode(ast) }

  override BaseAstNode getChild(int childIndex) {
    // Note a node can have several results for getChild(n) because some
    // nodes have multiple different types of child (e.g. a File has a
    // child expression, the package name, and child declarations whose
    // indices may clash), so we renumber them:
    result = TAstNode(ast.getUniquelyNumberedChild(childIndex))
  }

  override string toString() { result = qlClass(ast) + ast }

  final override Location getLocation() { result = ast.getLocation() }

  final override FuncDef getEnclosingFunction() {
    result = ast or result = ast.getEnclosingFunction()
  }
}

/**
 * A node representing an `Expr`.
 */
class ExprNode extends BaseAstNode {
  override Expr ast;

  override string getProperty(string key) {
    result = super.getProperty(key)
    or
    key = "Value" and
    result = qlClass(ast) + ast.getExactValue()
    or
    key = "Type" and
    not ast.getType() instanceof InvalidType and
    result = ast.getType().pp()
  }
}

/**
 * A node representing a `File`
 */
class FileNode extends BaseAstNode {
  override File ast;

  private string getRelativePath() { result = ast.getRelativePath() }

  private int getSortOrder() {
    rank[result](FileNode fn | any() | fn order by fn.getRelativePath()) = this
  }

  override string getProperty(string key) {
    result = super.getProperty(key)
    or
    key = "semmle.order" and
    result = getSortOrder().toString()
  }

  /**
   * Gets a child of this node, renumbering `packageNode`, our parent's
   * `oldPackageIndex`th child, as the first child and moving others accordingly.
   */
  private BaseAstNode getChildPackageFirst(
    int childIndex, BaseAstNode packageNode, int oldPackageIndex
  ) {
    super.getChild(oldPackageIndex) = packageNode and
    (
      childIndex = 0 and result = packageNode
      or
      result =
        rank[childIndex](BaseAstNode node, int i |
          node = super.getChild(i) and i != oldPackageIndex
        |
          node order by i
        )
    )
  }

  /**
   * Gets a child of this node, moving the package-name expression to the front
   * of the list if one exists.
   */
  override BaseAstNode getChild(int childIndex) {
    if exists(ast.getPackageNameExpr())
    then result = getChildPackageFirst(childIndex, TAstNode(ast.getPackageNameExpr()), _)
    else result = super.getChild(childIndex)
  }

  /**
   * Gets the label for the edge from this node to the specified child. The package name
   * expression is named 'package'; others are numbered as per our parent's implementation
   * of this method.
   */
  override string getChildEdgeLabel(int childIndex) {
    if getChild(childIndex) = TAstNode(ast.getPackageNameExpr())
    then result = "package"
    else result = super.getChildEdgeLabel(childIndex)
  }

  /**
   * Gets the string representation of this File. Note explicitly using a relative path
   * like this rather than absolute as per default for the File class is a workaround for
   * a bug with codeql run test, which should replace absolute paths but currently does not.
   */
  override string toString() { result = qlClass(ast) + ast.getRelativePath() }
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
    target = source.getChild(childIndex)
  |
    key = "semmle.label" and value = source.getChildEdgeLabel(childIndex)
    or
    key = "semmle.order" and value = childIndex.toString()
  )
}

/** Holds if property `key` of the graph has the given `value`. */
query predicate graphProperties(string key, string value) {
  key = "semmle.graphKind" and value = "tree"
}
