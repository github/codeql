private import codeql.swift.generated.stmt.YieldStmt

class YieldStmt extends Generated::YieldStmt {
  override string toString() { result = "yield ..." }
}
