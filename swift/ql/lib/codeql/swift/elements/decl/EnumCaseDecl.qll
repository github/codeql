private import codeql.swift.generated.decl.EnumCaseDecl

class EnumCaseDecl extends EnumCaseDeclBase {
  override string toString() { result = "case ..." }
}
