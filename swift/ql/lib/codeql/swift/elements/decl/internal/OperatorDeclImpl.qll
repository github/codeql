private import codeql.swift.generated.decl.OperatorDecl

module Impl {
  class OperatorDecl extends Generated::OperatorDecl {
    override string toStringImpl() { result = this.getName() }
  }
}
