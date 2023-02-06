private import codeql.swift.generated.decl.AbstractFunctionDecl
private import codeql.swift.elements.decl.MethodDecl

/**
 * A function.
 */
class AbstractFunctionDecl extends Generated::AbstractFunctionDecl, Callable {
  override string toString() { result = this.getName() }
}

/**
 * A free (non-member) function.
 */
class FreeFunctionDecl extends AbstractFunctionDecl {
  FreeFunctionDecl() { not this instanceof MethodDecl }
}
