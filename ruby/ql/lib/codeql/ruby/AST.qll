import codeql.Locations
import ast.Call
import ast.Control
import ast.Constant
import ast.Erb
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
private import ast.internal.Synthesis
private import ast.internal.TreeSitter

cached
private module Cached {
  cached
  ModuleBase getEnclosingModule(Scope s) {
    result = s
    or
    not s instanceof ModuleBase and result = getEnclosingModule(s.getOuterScope())
  }

  cached
  MethodBase getEnclosingMethod(Scope s) {
    result = s
    or
    not s instanceof MethodBase and
    not s instanceof ModuleBase and
    result = getEnclosingMethod(s.getOuterScope())
  }
}

private import Cached

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

  /**
   * Gets a comma-separated list of the names of the primary CodeQL classes to
   * which this element belongs.
   */
  final string getPrimaryQlClasses() { result = concat(this.getAPrimaryQlClass(), ",") }

  /** Gets the enclosing module, if any. */
  ModuleBase getEnclosingModule() { result = getEnclosingModule(scopeOfInclSynth(this)) }

  /** Gets the enclosing method, if any. */
  MethodBase getEnclosingMethod() { result = getEnclosingMethod(scopeOfInclSynth(this)) }

  /** Gets a textual representation of this node. */
  cached
  string toString() { none() }

  /** Gets the location of this node. */
  Location getLocation() { result = getLocation(this) }

  /** Gets the file of this node. */
  final File getFile() { result = this.getLocation().getFile() }

  /** Gets a child node of this `AstNode`. */
  final AstNode getAChild() { result = this.getAChild(_) }

  /** Gets the parent of this `AstNode`, if this node is not a root node. */
  final AstNode getParent() { result.getAChild() = this }

  /**
   * Gets a child of this node, which can also be retrieved using a predicate
   * named `pred`.
   */
  cached
  AstNode getAChild(string pred) {
    pred = "getDesugared" and
    result = this.getDesugared()
  }

  /**
   * Holds if this node was synthesized to represent an implicit AST node not
   * present in the source code.  In the following example method call, the
   * receiver is an implicit `self` reference, for which there is a synthesized
   * `Self` node.
   *
   * ```rb
   * foo(123)
   * ```
   */
  final predicate isSynthesized() { this = getSynthChild(_, _) }

  /**
   * Gets the desugared version of this AST node, if any.
   *
   * For example, the desugared version of
   *
   * ```rb
   * x += y
   * ```
   *
   * is
   *
   * ```rb
   * x = x + y
   * ```
   *
   * when `x` is a variable. Whenever an AST node can be desugared,
   * then the desugared version is used in the control-flow graph.
   */
  final AstNode getDesugared() { result = getSynthChild(this, -1) }
}

/** A Ruby source file */
class RubyFile extends File {
  RubyFile() { ruby_ast_node_info(_, this, _, _) }

  /** Gets a token in this file. */
  private Ruby::Token getAToken() { result.getLocation().getFile() = this }

  /** Holds if `line` contains a token. */
  private predicate line(int line, boolean comment) {
    exists(Ruby::Token token, Location l |
      token = this.getAToken() and
      l = token.getLocation() and
      line in [l.getStartLine() .. l.getEndLine()] and
      if token instanceof @ruby_token_comment then comment = true else comment = false
    )
  }

  /** Gets the number of lines in this file. */
  int getNumberOfLines() { result = max([0, this.getAToken().getLocation().getEndLine()]) }

  /** Gets the number of lines of code in this file. */
  int getNumberOfLinesOfCode() { result = count(int line | this.line(line, false)) }

  /** Gets the number of lines of comments in this file. */
  int getNumberOfLinesOfComments() { result = count(int line | this.line(line, true)) }
}
