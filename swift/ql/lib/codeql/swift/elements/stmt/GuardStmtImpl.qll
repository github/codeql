private import codeql.swift.generated.stmt.GuardStmt

class GuardStmt extends Generated::GuardStmt {
  override string toString() { result = "guard ... else { ... }" }
}
