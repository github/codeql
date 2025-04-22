private import AstImport

class DoWhileStmt extends LoopStmt, TDoWhileStmt {
  override string toString() { result = "do...while..." }

  Expr getCondition() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, doWhileStmtCond(), result)
      or
      not synthChild(r, doWhileStmtCond(), _) and
      result = getResultAst(r.(Raw::DoWhileStmt).getCondition())
    )
  }

  final override StmtBlock getBody() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, doWhileStmtBody(), result)
      or
      not synthChild(r, doWhileStmtBody(), _) and
      result = getResultAst(r.(Raw::DoWhileStmt).getBody())
    )
  }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = doWhileStmtCond() and
    result = this.getCondition()
    or
    i = doWhileStmtBody() and
    result = this.getBody()
  }
}
