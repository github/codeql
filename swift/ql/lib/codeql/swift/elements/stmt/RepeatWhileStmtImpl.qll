private import codeql.swift.generated.stmt.RepeatWhileStmt

module Impl {
  class RepeatWhileStmt extends Generated::RepeatWhileStmt {
    override string toString() { result = "repeat { ... } while ... " }
  }
}
