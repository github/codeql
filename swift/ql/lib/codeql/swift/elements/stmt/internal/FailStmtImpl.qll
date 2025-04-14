private import codeql.swift.generated.stmt.FailStmt

module Impl {
  class FailStmt extends Generated::FailStmt {
    override string toStringImpl() { result = "fail" }
  }
}
