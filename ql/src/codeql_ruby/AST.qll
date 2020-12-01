import codeql.Locations
import codeql_ruby.ast.Method
import codeql_ruby.ast.Parameter
import codeql_ruby.ast.Pattern
import codeql_ruby.ast.Variable
private import codeql_ruby.Generated

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
  string describeQlClass() { result = "???" }

  /** Gets a textual representation of this node. */
  string toString() { result = "AstNode" }

  /** Gets the location if this node. */
  Location getLocation() { result = generated.getLocation() }
}
