/**
 * Provides queries to pretty-print a Go AST as a graph.
 */

import swift
import codeql.swift.generated.ParentChild

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
   * Holds if the AST for `e` should be printed. By default, holds for all.
   */
  predicate shouldPrint(Locatable e) { any() }
}

private predicate shouldPrint(Locatable e) { any(PrintAstConfiguration config).shouldPrint(e) }

/**
 * An AST node that should be printed.
 */
private newtype TPrintAstNode =
  TLocatable(Locatable ast) {
    // Only consider resolved nodes (that is not within the hidden conversion AST)
    ast = ast.resolve()
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
   * Gets the child node at index `index`. Child indices must be unique,
   * but need not be contiguous.
   */
  abstract predicate hasChild(PrintAstNode child, int index, string accessor);

  /**
   * Holds if this node should be printed in the output.
   */
  abstract predicate shouldBePrinted();

  /**
   * Gets the location of this node in the source code.
   */
  abstract Location getLocation();

  /**
   * Gets the value of an additional property of this node, where the name of
   * the property is `key`.
   */
  string getProperty(string key) { none() }
}

/**
 * A graph node representing a real Locatable node.
 */
class PrintLocatable extends PrintAstNode, TLocatable {
  Locatable ast;

  PrintLocatable() { this = TLocatable(ast) }

  final override predicate shouldBePrinted() { shouldPrint(ast) }

  override predicate hasChild(PrintAstNode child, int index, string accessor) {
    child = TLocatable(getChildAndAccessor(ast, index, accessor))
  }

  override string toString() { result = "[" + concat(ast.getPrimaryQlClasses(), ", ") + "] " + ast }

  final override Location getLocation() { result = ast.getLocation() }
}

cached
private int getOrder(PrintAstNode node) {
  node =
    rank[result](PrintAstNode n, Location loc |
      loc = n.getLocation()
    |
      n
      order by
        loc.getFile().getName(), loc.getStartLine(), loc.getStartColumn(), loc.getEndLine(),
        loc.getEndColumn()
    )
}

/** Holds if `node` belongs to the output tree, and its property `key` has the given `value`. */
query predicate nodes(PrintAstNode node, string key, string value) {
  node.shouldBePrinted() and
  (
    key = "semmle.label" and value = node.toString()
    or
    key = "semmle.order" and value = getOrder(node).toString()
    or
    value = node.getProperty(key)
  )
}

/**
 * Holds if `target` is a child of `source` in the AST, and property `key` of the edge has the
 * given `value`.
 */
query predicate edges(PrintAstNode source, PrintAstNode target, string key, string value) {
  source.shouldBePrinted() and
  target.shouldBePrinted() and
  exists(int index, string accessor | source.hasChild(target, index, accessor) |
    key = "semmle.label" and value = accessor
    or
    key = "semmle.order" and value = index.toString()
  )
}

/** Holds if property `key` of the graph has the given `value`. */
query predicate graphProperties(string key, string value) {
  key = "semmle.graphKind" and value = "tree"
}
