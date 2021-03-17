private import codeql_ruby.AST
private import internal.AST
private import internal.Variable
private import internal.TreeSitter

/** An access to a constant. */
class ConstantAccess extends Expr, TConstantAccess {
  /** Gets the name of the constant being accessed. */
  string getName() { none() }

  /**
   * Gets the expression used in the access's scope resolution operation, if
   * any. In the following example, the result is the `Call` expression for
   * `foo()`.
   *
   * ```rb
   * foo()::MESSAGE
   * ```
   *
   * However, there is no result for the following example, since there is no
   * scope resolution operation.
   *
   * ```rb
   * MESSAGE
   * ```
   */
  Expr getScopeExpr() { none() }

  /**
   * Holds if the access uses the scope resolution operator to refer to the
   * global scope, as in this example:
   *
   * ```rb
   * ::MESSAGE
   * ```
   */
  predicate hasGlobalScope() { none() }

  override string toString() { result = this.getName() }

  override AstNode getAChild(string pred) { pred = "getScopeExpr" and result = this.getScopeExpr() }
}

private class TokenConstantAccess extends ConstantAccess, TTokenConstantAccess {
  private Generated::Constant g;

  TokenConstantAccess() { this = TTokenConstantAccess(g) }

  final override string getName() { result = g.getValue() }
}

private class ScopeResolutionConstantAccess extends ConstantAccess, TScopeResolutionConstantAccess {
  private Generated::ScopeResolution g;
  private Generated::Constant constant;

  ScopeResolutionConstantAccess() { this = TScopeResolutionConstantAccess(g, constant) }

  final override string getName() { result = constant.getValue() }

  final override Expr getScopeExpr() { toGenerated(result) = g.getScope() }

  final override predicate hasGlobalScope() { not exists(g.getScope()) }
}

/**
 * A use (read) of a constant.
 *
 * For example, the right-hand side of the assignment in:
 *
 * ```rb
 * x = Foo
 * ```
 *
 * Or the superclass `Bar` in this example:
 *
 * ```rb
 * class Foo < Bar
 * end
 * ```
 */
class ConstantReadAccess extends ConstantAccess {
  ConstantReadAccess() {
    not this instanceof ConstantWriteAccess
    or
    // `X` in `X ||= 10` is considered both a read and a write
    this = any(AssignOperation a).getLeftOperand()
  }

  final override string getAPrimaryQlClass() { result = "ConstantReadAccess" }
}

/**
 * A definition of a constant.
 *
 * Examples:
 *
 * ```rb
 * Foo = 1             # defines constant Foo as an integer
 * M::Foo = 1          # defines constant Foo as an integer in module M
 *
 * class Bar; end      # defines constant Bar as a class
 * class M::Bar; end   # defines constant Bar as a class in module M
 *
 * module Baz; end     # defines constant Baz as a module
 * module M::Baz; end  # defines constant Baz as a module in module M
 * ```
 */
class ConstantWriteAccess extends ConstantAccess {
  ConstantWriteAccess() {
    explicitAssignmentNode(toGenerated(this), _) or this instanceof TNamespace
  }

  override string getAPrimaryQlClass() { result = "ConstantWriteAccess" }
}

/**
 * A definition of a constant via assignment. For example, the left-hand
 * operand in the following example:
 *
 * ```rb
 * MAX_SIZE = 100
 * ```
 */
class ConstantAssignment extends ConstantWriteAccess, LhsExpr {
  override string getAPrimaryQlClass() { result = "ConstantAssignment" }
}
