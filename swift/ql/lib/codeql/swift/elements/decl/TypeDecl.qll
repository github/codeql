private import codeql.swift.generated.decl.TypeDecl

class TypeDecl extends TypeDeclBase {
  override string toString() { result = this.getName() }
}
