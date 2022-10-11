private import codeql.swift.generated.stmt.FallthroughStmt

class FallthroughStmt extends FallthroughStmtBase {
  override string toString() { result = "fallthrough" }
}
