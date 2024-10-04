private import codeql.swift.generated.decl.EnumCaseDecl

module Impl {
  class EnumCaseDecl extends Generated::EnumCaseDecl {
    override string toString() { result = "case ..." }
  }
}
