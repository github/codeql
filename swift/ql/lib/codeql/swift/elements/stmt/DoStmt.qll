private import codeql.swift.generated.stmt.DoStmt

class DoStmt extends DoStmtBase {
  override string toString() { result = "do { ... }" }
}
