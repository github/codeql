private import codeql.swift.generated.stmt.DeferStmt

module Impl {
  class DeferStmt extends Generated::DeferStmt {
    override string toStringImpl() { result = "defer { ... }" }
  }
}
