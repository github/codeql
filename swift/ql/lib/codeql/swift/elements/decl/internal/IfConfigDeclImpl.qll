private import codeql.swift.generated.decl.IfConfigDecl

module Impl {
  class IfConfigDecl extends Generated::IfConfigDecl {
    override string toStringImpl() { result = "#if ..." }
  }
}
