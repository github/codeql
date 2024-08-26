import powershell

class BreakStmt extends GotoStmt, Stmt {
  override SourceLocation getLocation() { break_statement_location(this, result) }

  override string toString() { result = "continue" }
}
