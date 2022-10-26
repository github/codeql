private import codeql.swift.generated.decl.AbstractFunctionDecl

class AbstractFunctionDecl extends AbstractFunctionDeclBase {
  override string toString() { result = this.getName() }

  /**
   * Holds if this function is called `funcName`.
   */
  predicate hasName(string funcName) { this.getName() = funcName }
}
