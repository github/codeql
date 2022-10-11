private import codeql.swift.generated.stmt.ThrowStmt

class ThrowStmt extends ThrowStmtBase {
  override string toString() { result = "throw ..." }
}
