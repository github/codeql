/**
 * Provides classes representing the abstract syntax tree (AST) of PHP programs.
 */

import codeql.Locations
import ast.Call
import ast.Control
import ast.Expr
import ast.Literal
import ast.Function
import ast.ClassLike
import ast.Parameter
import ast.Statement
import ast.Variable
private import ast.internal.AST
private import ast.internal.TreeSitter
private import Customizations

/**
 * A node in the abstract syntax tree. This class is the base class for all PHP
 * program elements.
 */
class AstNode extends TPhpAstNode {
  /**
   * Gets the name of a primary CodeQL class to which this node belongs.
   */
  string getAPrimaryQlClass() { result = "???" }

  /**
   * Gets a comma-separated list of the names of the primary CodeQL classes to
   * which this element belongs.
   */
  final string getPrimaryQlClasses() { result = concat(this.getAPrimaryQlClass(), ",") }

  /** Gets a textual representation of this node. */
  cached
  string toString() { none() }

  /** Gets the location of this node. */
  Location getLocation() { php_ast_node_location(this, result) }

  /** Gets the file of this node. */
  final File getFile() { result = this.getLocation().getFile() }

  /** Gets a child node of this `AstNode`. */
  AstNode getAChild() { php_ast_node_parent(result, this, _) }

  /** Gets the `i`th child of this `AstNode`. */
  AstNode getChild(int i) { php_ast_node_parent(result, this, i) }

  /** Gets the parent of this `AstNode`, if this node is not a root node. */
  AstNode getParent() { php_ast_node_parent(this, result, _) }

  /** Gets the index of this node within its parent. */
  int getIndex() { php_ast_node_parent(this, _, result) }
}

/** A PHP program (source file). */
class Program extends AstNode, @php_program {
  override string getAPrimaryQlClass() { result = "Program" }

  override string toString() { result = "program" }

  /** Gets the `i`th statement in this program. */
  Stmt getStatement(int i) { php_program_child(this, i, result) }

  /** Gets a statement in this program. */
  Stmt getAStatement() { result = this.getStatement(_) }

  /** Gets the number of statements in this program. */
  int getNumberOfStatements() { result = count(int i | php_program_child(this, i, _)) }
}
