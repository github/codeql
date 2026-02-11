private import codeql.swift.generated.stmt.DoStmt

module Impl {
  class DoStmt extends Generated::DoStmt {
    override string toStringImpl() { result = "do { ... }" }
  }
}
