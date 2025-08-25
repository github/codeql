private import codeql.swift.generated.stmt.BreakStmt

module Impl {
  class BreakStmt extends Generated::BreakStmt {
    override string toStringImpl() {
      result = "break " + this.getTargetName()
      or
      not this.hasTargetName() and
      result = "break"
    }
  }
}
