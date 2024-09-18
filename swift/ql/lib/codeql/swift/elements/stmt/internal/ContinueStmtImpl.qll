private import codeql.swift.generated.stmt.ContinueStmt

module Impl {
  class ContinueStmt extends Generated::ContinueStmt {
    override string toString() {
      result = "continue " + this.getTargetName()
      or
      not this.hasTargetName() and
      result = "continue"
    }
  }
}
