private import codeql.swift.generated.stmt.FallthroughStmt

module Impl {
  class FallthroughStmt extends Generated::FallthroughStmt {
    override string toStringImpl() { result = "fallthrough" }
  }
}
