private import codeql.swift.generated.stmt.PoundAssertStmt

class PoundAssertStmt extends PoundAssertStmtBase {
  override string toString() { result = "#assert ..." }
}
