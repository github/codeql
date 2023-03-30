private import codeql.swift.generated.pattern.NamedPattern
private import codeql.swift.elements.decl.VarDecl

/**
 * A pattern that corresponds to a fresh variable binding.
 *
 * For example, `x` as in `if case let .some(x) = ...` is a `NamedPattern`,
 * whereas `y` as in `if case .some(y) = ...` is instead an `ExprPattern`.
 */
class NamedPattern extends Generated::NamedPattern {
  /**
   * Holds if this named pattern has a corresponding `VarDecl`.
   * This will be the case as long as the variable is subsequently used.
   */
  predicate hasVarDecl() { exists(this.getVarDecl()) }

  /**
   * Gets the `VarDecl` bound by this named pattern, if any.
   * This will be the case as long as the variable is subsequently used.
   */
  VarDecl getVarDecl() {
    this.getImmediateEnclosingPattern*() = result.getParentPattern().getFullyUnresolved() and
    result.getName() = this.getName()
  }

  override string toString() { result = this.getName() }
}
