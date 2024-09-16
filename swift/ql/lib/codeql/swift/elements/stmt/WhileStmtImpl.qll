private import codeql.swift.generated.stmt.WhileStmt

module Impl {
  class WhileStmt extends Generated::WhileStmt {
    override string toString() { result = "while ... { ... }" }
  }
}
