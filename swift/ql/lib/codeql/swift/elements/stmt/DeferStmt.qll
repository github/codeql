private import codeql.swift.generated.stmt.DeferStmt

class DeferStmt extends DeferStmtBase {
  override string toString() { result = "defer { ... }" }
}
