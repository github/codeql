import powershell

class ContinueStmt extends GotoStmt, @continue_statement {
  override SourceLocation getLocation() { continue_statement_location(this, result) }

  override string toString() { result = "continue" }
}
