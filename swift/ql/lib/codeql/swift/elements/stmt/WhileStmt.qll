private import codeql.swift.generated.stmt.WhileStmt

class WhileStmt extends Generated::WhileStmt {
  override string toString() { result = "while ... { ... }" }
}
