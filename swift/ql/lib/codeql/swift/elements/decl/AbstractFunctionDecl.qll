private import codeql.swift.generated.decl.AbstractFunctionDecl

class AbstractFunctionDecl extends Generated::AbstractFunctionDecl {
  override string toString() { result = this.getName() }
}
