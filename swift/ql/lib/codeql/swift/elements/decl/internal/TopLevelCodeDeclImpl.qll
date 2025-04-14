private import codeql.swift.generated.decl.TopLevelCodeDecl

module Impl {
  class TopLevelCodeDecl extends Generated::TopLevelCodeDecl {
    override string toStringImpl() { result = this.getBody().toStringImpl() }
  }
}
