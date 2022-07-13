private import codeql.swift.generated.stmt.BreakStmt

class BreakStmt extends BreakStmtBase {
  override string toString() {
    result = "break " + this.getTargetName()
    or
    not this.hasTargetName() and
    result = "break"
  }
}
