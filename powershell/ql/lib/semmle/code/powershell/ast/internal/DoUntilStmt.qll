private import AstImport

class DoUntilStmt extends LoopStmt, TDoUntilStmt {
  override string toString() { result = "do...until..." }

  Expr getCondition() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, doUntilStmtCond(), result)
      or
      not synthChild(r, doUntilStmtCond(), _) and
      result = getResultAst(r.(Raw::DoUntilStmt).getCondition())
    )
  }

  final override StmtBlock getBody() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, doUntilStmtBody(), result)
      or
      not synthChild(r, doUntilStmtBody(), _) and
      result = getResultAst(r.(Raw::DoUntilStmt).getBody())
    )
  }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = doUntilStmtCond() and result = this.getCondition()
    or
    i = doUntilStmtBody() and result = this.getBody()
  }
}
