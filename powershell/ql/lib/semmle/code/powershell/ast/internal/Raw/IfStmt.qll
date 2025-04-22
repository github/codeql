private import Raw

class IfStmt extends @if_statement, Stmt {
  override SourceLocation getLocation() { if_statement_location(this, result) }

  PipelineBase getCondition(int i) { if_statement_clause(this, i, result, _) }

  PipelineBase getACondition() { result = this.getCondition(_) }

  StmtBlock getThen(int i) { if_statement_clause(this, i, _, result) }

  int getNumberOfConditions() { result = count(this.getACondition()) }

  StmtBlock getAThen() { result = this.getThen(_) }

  /** ..., if any. */
  StmtBlock getElse() { if_statement_else(this, result) }

  predicate hasElse() { exists(this.getElse()) }

  final override Ast getChild(ChildIndex i) {
    i = IfStmtElse() and
    result = this.getElse()
    or
    exists(int index |
      i = IfStmtCond(index) and
      result = this.getCondition(index)
      or
      i = IfStmtThen(index) and
      result = this.getThen(index)
    )
  }
}
