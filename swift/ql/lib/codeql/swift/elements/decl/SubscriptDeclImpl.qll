private import codeql.swift.generated.decl.SubscriptDecl

module Impl {
  class SubscriptDecl extends Generated::SubscriptDecl {
    override string toString() { result = "subscript ..." }
  }
}
