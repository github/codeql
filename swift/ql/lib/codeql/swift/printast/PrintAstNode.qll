/**
 * Provides classes used to pretty-print a Go AST as a graph.
 * This is factored out of `PrintAst.qll` for testing purposes.
 */

import swift
import codeql.swift.generated.ParentChild

private newtype TPrintAstConfiguration = TMakePrintAstConfiguration()

/**
 * The hook to customize the files and functions printed by this module.
 */
class PrintAstConfiguration extends TPrintAstConfiguration {
  /**
   * Gets the string representation of this singleton
   */
  string toString() { result = "PrintAstConfiguration" }

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
