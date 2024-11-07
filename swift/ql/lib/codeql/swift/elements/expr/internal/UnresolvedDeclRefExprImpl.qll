private import codeql.swift.generated.expr.UnresolvedDeclRefExpr

module Impl {
  class UnresolvedDeclRefExpr extends Generated::UnresolvedDeclRefExpr {
    override string toString() {
      result = this.getName() + " (unresolved)"
      or
      not this.hasName() and result = "(unresolved)"
    }
  }
}
