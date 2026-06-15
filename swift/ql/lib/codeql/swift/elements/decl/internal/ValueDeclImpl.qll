private import codeql.swift.generated.decl.ValueDecl
private import codeql.swift.elements.decl.CapturedDecl
private import codeql.swift.elements.expr.DeclRefExpr

module Impl {
  /**
   * A declaration that introduces a value with a type.
   */
  class ValueDecl extends Generated::ValueDecl {
    /**
     * Gets a capture of this declaration in the scope of a closure.
     */
    CapturedDecl asCapturedDecl() { result.getDecl() = this }

    /**
     * Holds if this declaration is captured by a closure.
     */
    predicate isCaptured() { exists(this.asCapturedDecl()) }

    /**
     * Gets an expression that references this declaration.
     */
    DeclRefExpr getAnAccess() { result.getDecl() = this }
  }
}
