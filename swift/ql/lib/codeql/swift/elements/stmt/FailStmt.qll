private import codeql.swift.generated.stmt.FailStmt

class FailStmt extends FailStmtBase {
  override string toString() { result = "fail" }
}
