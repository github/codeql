private import AstImport

class TrapStmt extends Stmt, TTrapStmt {
  StmtBlock getBody() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, trapStmtBody(), result)
      or
      not synthChild(r, trapStmtBody(), _) and
      result = getResultAst(r.(Raw::TrapStmt).getBody())
    )
  }

  TypeConstraint getTypeConstraint() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, trapStmtTypeConstraint(), result)
      or
      not synthChild(r, trapStmtTypeConstraint(), _) and
      result = getResultAst(r.(Raw::TrapStmt).getTypeConstraint())
    )
  }

  override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = trapStmtBody() and
    result = this.getBody()
    or
    i = trapStmtTypeConstraint() and
    result = this.getTypeConstraint()
  }

  override string toString() { result = "trap {...}" }
}
