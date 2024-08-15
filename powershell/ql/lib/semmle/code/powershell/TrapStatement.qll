import powershell

class TrapStmt extends @trap_statement, Stmt {
  override SourceLocation getLocation() { trap_statement_location(this, result) }

  override string toString() { result = "TrapStatement at: " + this.getLocation().toString() }
}
