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
  } or
  TConversion(Expr conv) { conv.isConversion() } or
  TConversionContainer(Expr e) { e = e.resolve() and e.hasConversions() }

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

private string prettyPrint(Locatable e) {
  result = "[" + concat(e.getPrimaryQlClasses(), ", ") + "] " + e
}

/**
 * A graph node representing a real Locatable node.
 */
class PrintLocatable extends PrintAstNode, TLocatable {
  Locatable ast;

  PrintLocatable() { this = TLocatable(ast) }

  override string toString() { result = prettyPrint(ast) }

  final override predicate shouldBePrinted() { shouldPrint(ast) }

  override predicate hasChild(PrintAstNode child, int index, string accessor) {
    child = TLocatable(getChildAndAccessor(ast, index, accessor))
  }

  final override Location getLocation() { result = ast.getLocation() }
}

/**
 * A graph node representing a conversion.
 */
class PrintConversion extends PrintAstNode, TConversion {
  Expr conv;

  PrintConversion() { this = TConversion(conv) }

  override string toString() { result = prettyPrint(conv) }

  final override predicate shouldBePrinted() { shouldPrint(conv.resolve()) }

  override predicate hasChild(PrintAstNode child, int index, string accessor) { none() }

  final override Location getLocation() { result = conv.getLocation() }
}

/**
 * A graph node representing a virtual container for conversions.
 */
class PrintConversionContainer extends PrintAstNode, TConversionContainer {
  Expr convertee;

  PrintConversionContainer() { this = TConversionContainer(convertee) }

  override string toString() { result = "" }

  final override predicate shouldBePrinted() { shouldPrint(convertee) }

  override predicate hasChild(PrintAstNode child, int index, string accessor) {
    child = TConversion(convertee.getConversion(index)) and
    accessor = "getConversion(" + index + ")"
  }

  final override Location getLocation() { result = convertee.getFullyConverted().getLocation() }
}

/** A graph node specialization for expressions to show conversions. */
class PrintExpr extends PrintLocatable {
  override Expr ast;

  override predicate hasChild(PrintAstNode child, int index, string accessor) {
    super.hasChild(child, index, accessor)
    or
    ast.hasConversions() and
    index = -1 and
    accessor = "conversions" and
    child = TConversionContainer(ast)
  }
}
