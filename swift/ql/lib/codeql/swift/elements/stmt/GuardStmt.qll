private import codeql.swift.generated.stmt.GuardStmt

class GuardStmt extends GuardStmtBase {
  override string toString() { result = "guard ... else { ... }" }
}
