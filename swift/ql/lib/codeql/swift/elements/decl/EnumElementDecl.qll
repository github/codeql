private import codeql.swift.generated.decl.EnumElementDecl

class EnumElementDecl extends EnumElementDeclBase {
  override string toString() { result = this.getName() }
}
