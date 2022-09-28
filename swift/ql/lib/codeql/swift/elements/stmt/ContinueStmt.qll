private import codeql.swift.generated.stmt.ContinueStmt

class ContinueStmt extends ContinueStmtBase {
  override string toString() {
    result = "continue " + this.getTargetName()
    or
    not this.hasTargetName() and
    result = "continue"
  }
}
