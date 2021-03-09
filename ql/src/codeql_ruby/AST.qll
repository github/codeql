import codeql.Locations
import ast.Call
import ast.Control
import ast.Constant
import ast.Expr
import ast.Literal
import ast.Method
import ast.Module
import ast.Parameter
import ast.Operation
import ast.Pattern
import ast.Scope
import ast.Statement
import ast.Variable
private import ast.internal.AST

/**
 * A node in the abstract syntax tree. This class is the base class for all Ruby
 * program elements.
 */
class AstNode extends @ast_node {
  AstNode::Range range;

  AstNode() { range = this }

  /**
   * Gets the name of a primary CodeQL class to which this node belongs.
   *
   * This predicate always has a result. If no primary class can be
   * determined, the result is `"???"`. If multiple primary classes match,
   * this predicate can have multiple results.
   */
  string getAPrimaryQlClass() { result = "???" }

  /** Gets a textual representation of this node. */
  final string toString() { result = range.toString() }

  /** Gets the location of this node. */
  final Location getLocation() { result = range.getLocation() }

  /** Gets a child node of this `AstNode`. */
  final AstNode getAChild() { range.child(_, result) }

  /** Gets the parent of this `AstNode`, if this node is not a root node. */
  final AstNode getParent() { result.getAChild() = this }
}
