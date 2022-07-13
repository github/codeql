private import codeql.swift.generated.decl.AbstractFunctionDecl

class AbstractFunctionDecl extends AbstractFunctionDeclBase {
  override string toString() { result = this.getName() }
}
