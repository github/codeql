import Raw

class BreakStmt extends GotoStmt, @break_statement {
  override SourceLocation getLocation() { break_statement_location(this, result) }
}
