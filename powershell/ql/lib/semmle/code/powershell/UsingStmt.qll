import powershell

class UsingStmt extends @using_statement, Stmt {
  override SourceLocation getLocation() { using_statement_location(this, result) }

  override string toString() { result = "using ..." }
}
