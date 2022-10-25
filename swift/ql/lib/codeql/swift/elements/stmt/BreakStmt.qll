private import codeql.swift.generated.stmt.BreakStmt

class BreakStmt extends Generated::BreakStmt {
  override string toString() {
    result = "break " + this.getTargetName()
    or
    not this.hasTargetName() and
    result = "break"
  }
}
