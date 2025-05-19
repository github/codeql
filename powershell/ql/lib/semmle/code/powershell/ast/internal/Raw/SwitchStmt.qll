private import Raw

class SwitchStmt extends LabeledStmt, @switch_statement {
  final override Location getLocation() { switch_statement_location(this, result) }

  PipelineBase getCondition() { switch_statement(this, result, _) }

  StmtBlock getDefault() { switch_statement_default(this, result) }

  StmtBlock getCase(int i, Expr e) { switch_statement_clauses(this, i, e, result) }

  StmtBlock getCase(int i) { result = this.getCase(i, _) }

  StmtBlock getACase() { result = this.getCase(_) }

  StmtBlock getCaseForExpr(Expr e) { result = this.getCase(_, e) }

  Expr getPattern(int i) { exists(this.getCase(i, result)) }

  Expr getAPattern() { result = this.getPattern(_) }

  int getNumberOfCases() { result = count(this.getACase()) }

  final override Ast getChild(ChildIndex i) {
    i = SwitchStmtCond() and
    result = this.getCondition()
    or
    i = SwitchStmtDefault() and
    result = this.getDefault()
    or
    exists(int index |
      i = SwitchStmtCase(index) and
      result = this.getCase(index)
      or
      i = SwitchStmtPat(index) and
      result = this.getPattern(index)
    )
  }
}
