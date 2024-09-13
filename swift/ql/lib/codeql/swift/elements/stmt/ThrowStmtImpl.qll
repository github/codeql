private import codeql.swift.generated.stmt.ThrowStmt

class ThrowStmt extends Generated::ThrowStmt {
  override string toString() { result = "throw ..." }
}
