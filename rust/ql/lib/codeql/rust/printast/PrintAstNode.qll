/**
 * Provides classes used to pretty-print a Rust AST as a graph.
 * This is factored out of `PrintAst.qll` for testing purposes.
 */

import rust
import codeql.rust.elements.internal.generated.ParentChild

signature predicate shouldPrintSig(Locatable e);

module PrintAstNode<shouldPrintSig/1 shouldPrint> {
  /**
   * An AST node that should be printed.
   */
  private newtype TPrintAstNode = TPrintLocatable(Locatable ast) { shouldPrint(ast) }

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

  private string prettyPrint(Locatable e) { result = "[" + e.getPrimaryQlClasses() + "] " + e }

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

    override predicate hasChild(PrintAstNode child, int index, string label) {
      child = TPrintLocatable(any(Locatable c | c = getChildAndAccessor(ast, index, label)))
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
}
