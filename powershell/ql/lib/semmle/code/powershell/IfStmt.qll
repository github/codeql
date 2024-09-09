import powershell

class IfStmt extends @if_statement, Stmt {
  override SourceLocation getLocation() { if_statement_location(this, result) }

  override string toString() {
    if this.hasElse() then result = "if (...) {...} else {...}" else result = "if (...) {...}"
  }

  PipelineBase getCondition(int i) { if_statement_clause(this, i, result, _) }

  PipelineBase getACondition() { result = this.getCondition(_) }

  StmtBlock getThen(int i) { if_statement_clause(this, i, _, result) }

  /** ..., if any. */
  StmtBlock getElse() { if_statement_else(this, result) }

  predicate hasElse() { exists(this.getElse()) }
}
