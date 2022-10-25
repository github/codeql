private import codeql.swift.generated.stmt.PoundAssertStmt

class PoundAssertStmt extends Generated::PoundAssertStmt {
  override string toString() { result = "#assert ..." }
}
