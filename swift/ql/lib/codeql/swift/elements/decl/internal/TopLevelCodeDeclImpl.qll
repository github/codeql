private import codeql.swift.generated.decl.TopLevelCodeDecl

module Impl {
  class TopLevelCodeDecl extends Generated::TopLevelCodeDecl {
    override string toString() { result = this.getBody().toString() }
  }
}
