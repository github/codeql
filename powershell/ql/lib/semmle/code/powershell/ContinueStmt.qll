import powershell

class ContinueStmt extends GotoStmt, Stmt {
  override SourceLocation getLocation() { continue_statement_location(this, result) }

  override string toString() { result = "continue" }
}
