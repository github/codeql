private import codeql.swift.generated.stmt.ThrowStmt

module Impl {
  class ThrowStmt extends Generated::ThrowStmt {
    override string toString() { result = "throw ..." }
  }
}
