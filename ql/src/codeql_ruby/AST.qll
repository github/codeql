import codeql.Locations
import ast.Expr
import ast.Method
import ast.Parameter
import ast.Operation
import ast.Pattern
import ast.Variable
private import ast.internal.TreeSitter

/**
 * A node in the abstract syntax tree. This class is the base class for all Ruby
 * program elements.
 */
class AstNode extends @ast_node {
  Generated::AstNode generated;

  AstNode() { generated = this }

  /**
   * Gets the name of a primary CodeQL class to which this node belongs.
   *
   * This predicate always has a result. If no primary class can be
   * determined, the result is `"???"`. If multiple primary classes match,
   * this predicate can have multiple results.
   */
  string getAPrimaryQlClass() { result = "???" }

  /** Gets a textual representation of this node. */
  string toString() { result = "AstNode" }

  /** Gets the location if this node. */
  Location getLocation() { result = generated.getLocation() }
}
