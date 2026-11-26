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
     * Gets the name of the variable bound by this pattern.
     */
    string getName() { result = this.getVarDecl().getName() }

    override string toStringImpl() { result = this.getName() }
  }
}
