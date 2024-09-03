import powershell

class BreakStmt extends GotoStmt, @break_statement {
  override SourceLocation getLocation() { break_statement_location(this, result) }

  override string toString() { result = "break" }
}
