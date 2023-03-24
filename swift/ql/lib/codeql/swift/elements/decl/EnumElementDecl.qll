private import codeql.swift.generated.decl.EnumElementDecl

class EnumElementDecl extends Generated::EnumElementDecl {
  override string toString() { result = this.getName() }
}
