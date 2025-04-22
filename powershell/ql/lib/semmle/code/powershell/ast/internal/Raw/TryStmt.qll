private import Raw

class TryStmt extends @try_statement, Stmt {
  override SourceLocation getLocation() { try_statement_location(this, result) }

  CatchClause getCatchClause(int i) { try_statement_catch_clause(this, i, result) }

  CatchClause getACatchClause() { result = this.getCatchClause(_) }

  /** ..., if any. */
  StmtBlock getFinally() { try_statement_finally(this, result) }

  StmtBlock getBody() { try_statement(this, result) }

  predicate hasFinally() { exists(this.getFinally()) }

  final override Ast getChild(ChildIndex i) {
    i = TryStmtBody() and
    result = this.getBody()
    or
    exists(int index |
      i = TryStmtCatchClause(index) and
      result = this.getCatchClause(index)
    )
    or
    i = TryStmtFinally() and
    result = this.getFinally()
  }
}
