private import codeql.swift.generated.stmt.DeferStmt

class DeferStmt extends Generated::DeferStmt {
  override string toString() { result = "defer { ... }" }
}
