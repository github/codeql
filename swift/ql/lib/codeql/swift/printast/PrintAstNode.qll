/**
 * Provides classes used to pretty-print a Swift AST as a graph.
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
  predicate shouldPrint(Locatable e) { not e instanceof Diagnostics and not e instanceof MacroRole }
}

private predicate shouldPrint(Locatable e) { any(PrintAstConfiguration config).shouldPrint(e) }

/**
 * An AST node that should be printed.
 */
private newtype TPrintAstNode = TPrintLocatable(Locatable ast)

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
  abstract predicate hasChild(PrintAstNode child, int index, string label);

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

  /**
   * Gets the underlying AST node, if any.
   */
  abstract Locatable getAstNode();
}

private string prettyPrint(Locatable e) {
  result = "[" + concat(e.getPrimaryQlClasses(), ", ") + "] " + e
}

private class Unresolved extends Locatable {
  Unresolved() { this != this.resolve() }
}

/**
 * A graph node representing a real Locatable node.
 */
class PrintLocatable extends PrintAstNode, TPrintLocatable {
  Locatable ast;

  PrintLocatable() { this = TPrintLocatable(ast) }

  override string toString() { result = prettyPrint(ast) }

  final override predicate shouldBePrinted() { shouldPrint(ast) }

  override predicate hasChild(PrintAstNode child, int index, string label) {
    exists(Locatable c, int i, string accessor |
      c = getChildAndAccessor(ast, i, accessor) and
      (
        // use even indexes for normal children, leaving odd slots for conversions if any
        child = TPrintLocatable(c) and index = 2 * i and label = accessor
        or
        child = TPrintLocatable(c.getFullyUnresolved().(Unresolved)) and
        index = 2 * i + 1 and
        (
          if c instanceof Expr
          then label = accessor + ".getFullyConverted()"
          else label = accessor + ".getFullyUnresolved()"
        )
      )
    )
  }

  final override Locatable getAstNode() { result = ast }

  final override Location getLocation() { result = ast.getLocation() }
}

/**
 * A specialization of graph node for "unresolved" children, that is nodes in
 * the parallel conversion AST.
 */
class PrintUnresolved extends PrintLocatable {
  override Unresolved ast;

  override predicate hasChild(PrintAstNode child, int index, string label) {
    // only print immediate unresolved children from the "parallel" AST
    child = TPrintLocatable(getImmediateChildAndAccessor(ast, index, label).(Unresolved))
  }
}

private predicate hasPropertyWrapperElement(VarDecl d, Locatable a) {
  a = [d.getPropertyWrapperBackingVar(), d.getPropertyWrapperProjectionVar()] or
  a = [d.getPropertyWrapperBackingVarBinding(), d.getPropertyWrapperProjectionVarBinding()]
}

/**
 * A specialization of graph node for `VarDecl`, to add typing information and deal with ambiguity
 * over property wrapper children.
 */
class PrintVarDecl extends PrintLocatable {
  override VarDecl ast;

  override string getProperty(string key) { key = "Type" and result = ast.getType().toString() }

  override predicate hasChild(PrintAstNode child, int index, string label) {
    PrintLocatable.super.hasChild(child, index, label) and
    // exclude property wrapper related children when they are already listed in the enclosing
    // nominal type declaration or for a wrapped parameter for which this is a virtual local variable copy
    not exists(Locatable childAst |
      childAst = child.getAstNode() and
      hasPropertyWrapperElement(ast, childAst) and
      (
        childAst = ast.getDeclaringDecl().getAMember()
        or
        ast instanceof ConcreteVarDecl and hasPropertyWrapperElement(any(ParamDecl p), childAst)
      )
    )
  }
}

/**
 * A specialization of graph node for `Function`, to add typing information.
 */
class PrintFunction extends PrintLocatable {
  override Function ast;

  override string getProperty(string key) {
    key = "InterfaceType" and result = ast.getInterfaceType().toString()
  }
}

/**
 * A specialization of graph node for `PatternBindingDecl`, to solve ambiguity on `getInit`.
 * When a property wrapper is involved, `getInit` may become shared between the explicit binding and
 * the implicit compiler synthesized one.
 */
class PrintPatternBindingDecl extends PrintLocatable {
  override PatternBindingDecl ast;

  override predicate hasChild(PrintAstNode child, int index, string label) {
    PrintLocatable.super.hasChild(child, index, label) and
    // exclude `getInit` that are already the initializer of a variable that has this as a property wrapper backer
    not exists(Expr init, VarDecl var |
      init = child.getAstNode() and
      init = ast.getAnInit() and
      var.getPropertyWrapperBackingVarBinding() = ast and
      var.getParentInitializer() = init
    )
  }
}
