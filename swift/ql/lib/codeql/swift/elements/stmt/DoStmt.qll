private import codeql.swift.generated.stmt.DoStmt

class DoStmt extends Generated::DoStmt {
  override string toString() { result = "do { ... }" }
}
