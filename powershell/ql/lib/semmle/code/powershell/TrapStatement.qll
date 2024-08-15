import powershell

class TrapStatement extends @trap_statement, Statement {
  override SourceLocation getLocation() { trap_statement_location(this, result) }

  override string toString() { result = "TrapStatement at: " + this.getLocation().toString() }
}
