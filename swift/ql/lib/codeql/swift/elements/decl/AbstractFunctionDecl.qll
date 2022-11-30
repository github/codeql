private import codeql.swift.generated.decl.AbstractFunctionDecl
private import codeql.swift.elements.decl.MethodDecl

/**
 * A function.
 */
class AbstractFunctionDecl extends Generated::AbstractFunctionDecl {
  override string toString() { result = this.getName() }

  /**
   * Holds if this function is called `funcName`.
   */
  predicate hasName(string funcName) { this.getName() = funcName }
}

/**
 * A free (non-member) function.
 */
class FreeFunctionDecl extends AbstractFunctionDecl {
  FreeFunctionDecl() { not this instanceof MethodDecl }
}
