private import codeql.swift.generated.decl.AbstractFunctionDecl
private import codeql.swift.elements.decl.MethodDecl

class AbstractFunctionDecl extends Generated::AbstractFunctionDecl {
  override string toString() { result = this.getName() }

  /**
   * Holds if this function is called `funcName`.
   */
  predicate hasName(string funcName) { this.getName() = funcName }

  /**
   * Holds if this is a global (non-member) function called `funcName`.
   */
  predicate hasGlobalName(string funcName) {
    this.hasName(funcName) and
    not this instanceof MethodDecl
  }
}
