private import codeql.swift.generated.stmt.GuardStmt

module Impl {
  class GuardStmt extends Generated::GuardStmt {
    override string toStringImpl() { result = "guard ... else { ... }" }
  }
}
