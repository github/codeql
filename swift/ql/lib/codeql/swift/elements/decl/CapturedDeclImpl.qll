private import codeql.swift.generated.decl.CapturedDecl
private import codeql.swift.elements.Callable
private import codeql.swift.elements.expr.DeclRefExpr

module Impl {
  /**
   * A captured variable or function parameter in the scope of a closure.
   */
  class CapturedDecl extends Generated::CapturedDecl {
    override string toString() { result = this.getDecl().toString() }

    /**
     * Gets the closure or function that captures this variable.
     */
    Callable getScope() { result.getACapture() = this }

    /**
     * Get an access to this capture within the scope of its closure.
     */
    DeclRefExpr getAnAccess() {
      result.getEnclosingCallable() = this.getScope() and
      result.getDecl() = this.getDecl()
    }
  }
}
