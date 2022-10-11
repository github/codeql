private import codeql.swift.generated.stmt.ReturnStmt

class ReturnStmt extends ReturnStmtBase {
  override string toString() {
    if this.hasResult() then result = "return ..." else result = "return"
  }
}
