private import codeql.swift.generated.stmt.WhileStmt

class WhileStmt extends WhileStmtBase {
  override string toString() { result = "while ... { ... }" }
}
