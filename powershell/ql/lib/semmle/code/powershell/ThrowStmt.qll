import powershell

class ThrowStmt extends @throw_statement, Stmt {
  override SourceLocation getLocation() { throw_statement_location(this, result) }

  override string toString() {
    if this.hasPipeline() then result = "throw ..." else result = "throw"
  }

  Pipeline getPipeline() { throw_statement_pipeline(this, result) }

  predicate hasPipeline() { exists(this.getPipeline()) }
}
