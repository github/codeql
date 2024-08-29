import powershell

class IfStmt extends @if_statement, Stmt {
  override SourceLocation getLocation() { if_statement_location(this, result) }

  override string toString() {
    if this.hasElse() then result = "if (...) {...} else {...}" else result = "if (...) {...}"
  }

  PipelineBase getCondition(int i) { if_statement_clause(this, i, result, _) } // TODO: Change @ast to @pipeline_base in dbscheme

  PipelineBase getACondition() { result = this.getCondition(_) }

  StmtBlock getThen(int i) { if_statement_clause(this, i, _, result) } // TODO: Change @ast to @statement_block in dbscheme

  /** ..., if any. */
  StmtBlock getElse() { if_statement_else(this, result) } // TODO: Change @ast to @stmt_block in dbscheme

  predicate hasElse() { exists(this.getElse()) }
}
