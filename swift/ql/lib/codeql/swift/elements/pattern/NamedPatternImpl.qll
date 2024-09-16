private import codeql.swift.generated.pattern.NamedPattern
private import codeql.swift.elements.decl.VarDecl

module Impl {
  /**
   * A pattern that corresponds to a fresh variable binding.
   *
   * For example, `x` as in `if case let .some(x) = ...` is a `NamedPattern`,
   * whereas `y` as in `if case .some(y) = ...` is instead an `ExprPattern`.
   */
  class NamedPattern extends Generated::NamedPattern {
    /**
     * Holds if this named pattern has a corresponding `VarDecl`, which is currently always true.
     *
     * DEPRECATED: unless there was a compilation error, this will always hold.
     */
    deprecated predicate hasVarDecl() { exists(this.getVarDecl()) }

    /**
     * Gets the name of the variable bound by this pattern.
     */
    string getName() { result = this.getVarDecl().getName() }

    override string toString() { result = this.getName() }
  }
}
