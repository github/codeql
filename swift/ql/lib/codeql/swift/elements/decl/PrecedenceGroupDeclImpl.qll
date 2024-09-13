private import codeql.swift.generated.decl.PrecedenceGroupDecl

module Impl {
  class PrecedenceGroupDecl extends Generated::PrecedenceGroupDecl {
    override string toString() { result = "precedencegroup ..." }
  }
}
