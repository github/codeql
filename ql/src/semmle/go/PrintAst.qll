/**
 * Provides queries to pretty-print a Go AST as a graph.
 */

import go

/**
 * Hook to customize the functions printed by this module.
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
  predicate shouldPrintFunction(FuncDef func) { any() }
}

private predicate shouldPrintFunction(FuncDef func) {
  exists(PrintAstConfiguration config | config.shouldPrintFunction(func))
}

/**
 * An AST node that should be printed.
 */
private newtype TPrintAstNode =
  TAstNode(AstNode ast) {
    // Do print ast nodes without an enclosing function, e.g. file headers
    forall(FuncDef f | f = ast.getEnclosingFunction() | shouldPrintFunction(f))
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
  result = "[" + concat(el.describeQlClass(), ", ") + "] "
}

/**
 * Gets a child with the given index and of the given kind, if one exists.
 * Note that a given parent can have multiple children with the same index but differing kind.
 */
private AstNode getChildOfKind(AstNode parent, string kind, int i) {
  kind = "expr" and result = parent.(ExprParent).getChildExpr(i)
  or
  kind = "gomodexpr" and result = parent.(GoModExprParent).getChildGoModExpr(i)
  or
  kind = "stmt" and result = parent.(StmtParent).getChildStmt(i)
  or
  kind = "decl" and result = parent.(DeclParent).getDecl(i)
  or
  kind = "spec" and result = parent.(GenDecl).getSpec(i)
  or
  kind = "field" and fields(result, parent, i)
}

/**
 * Get an AstNode child, ordered by child kind and then by index
 */
private AstNode getUniquelyNumberedChild(AstNode node, int index) {
  result =
    rank[index + 1](AstNode child, string kind, int i |
      child = getChildOfKind(node, kind, i)
    |
      child order by kind, i
    )
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
    result = TAstNode(getUniquelyNumberedChild(ast, childIndex))
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

query predicate nodes(PrintAstNode node, string key, string value) {
  node.shouldPrint() and
  value = node.getProperty(key)
}

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

query predicate graphProperties(string key, string value) {
  key = "semmle.graphKind" and value = "tree"
}
