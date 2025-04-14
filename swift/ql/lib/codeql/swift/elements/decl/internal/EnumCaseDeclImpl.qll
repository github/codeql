private import codeql.swift.generated.decl.EnumCaseDecl

module Impl {
  class EnumCaseDecl extends Generated::EnumCaseDecl {
    override string toStringImpl() { result = "case ..." }
  }
}
