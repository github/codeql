private import codeql.swift.generated.decl.EnumCaseDecl

class EnumCaseDecl extends Generated::EnumCaseDecl {
  override string toString() { result = "case ..." }
}
