private import codeql.swift.generated.expr.SuperRefExpr
private import codeql.swift.elements.decl.Method

module Impl {
  /** A reference to `super`. */
  class SuperRefExpr extends Generated::SuperRefExpr {
    override string toString() { result = "super" }

    Method getDeclaringMethod() { this.getSelf() = result.getSelfParam() }
  }
}
