private import Raw

class TrapStmt extends @trap_statement, Stmt {
  override SourceLocation getLocation() { trap_statement_location(this, result) }

  StmtBlock getBody() { trap_statement(this, result) } // TODO: Fix type in dbscheme

  TypeConstraint getTypeConstraint() { trap_statement_type(this, result) }

  override Ast getChild(ChildIndex i) {
    i = TrapStmtBody() and
    result = this.getBody()
    or
    i = TrapStmtTypeConstraint() and
    result = this.getTypeConstraint()
  }
}
