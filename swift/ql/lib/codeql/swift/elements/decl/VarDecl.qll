private import codeql.swift.generated.decl.VarDecl

class VarDecl extends VarDeclBase {
  override string toString() { result = this.getName() }
}
