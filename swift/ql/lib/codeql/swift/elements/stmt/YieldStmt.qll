private import codeql.swift.generated.stmt.YieldStmt

class YieldStmt extends YieldStmtBase {
  override string toString() { result = "yield ..." }
}
