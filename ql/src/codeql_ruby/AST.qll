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
private import ast.internal.Scope

/**
 * A node in the abstract syntax tree. This class is the base class for all Ruby
 * program elements.
 */
class AstNode extends TAstNode {
  /**
   * Gets the name of a primary CodeQL class to which this node belongs.
   *
   * This predicate always has a result. If no primary class can be
   * determined, the result is `"???"`. If multiple primary classes match,
   * this predicate can have multiple results.
   */
  string getAPrimaryQlClass() { result = "???" }

  /** Gets the enclosing module, if any. */
  ModuleBase getEnclosingModule() {
    exists(Scope::Range s |
      s = scopeOf(toGeneratedInclSynth(this)) and
      toGeneratedInclSynth(result) = s.getEnclosingModule()
    )
  }

  /** Gets the enclosing method, if any. */
  MethodBase getEnclosingMethod() {
    exists(Scope::Range s |
      s = scopeOf(toGeneratedInclSynth(this)) and
      toGeneratedInclSynth(result) = s.getEnclosingMethod()
    )
  }

  /** Gets a textual representation of this node. */
  cached
  string toString() { none() }

  /** Gets the location of this node. */
  Location getLocation() { result = toGeneratedInclSynth(this).getLocation() }

  /** Gets a child node of this `AstNode`. */
  final AstNode getAChild() { result = this.getAChild(_) }

  /** Gets the parent of this `AstNode`, if this node is not a root node. */
  final AstNode getParent() { result.getAChild() = this }

  /**
   * Gets a child of this node, which can also be retrieved using a predicate
   * named `pred`.
   */
  cached
  AstNode getAChild(string pred) { none() }
}
