private import AstImport

class WhileStmt extends LoopStmt, TWhileStmt {
  override string toString() { result = "while(...) {...}" }

  Expr getCondition() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, whileStmtCond(), result)
      or
      not synthChild(r, whileStmtCond(), _) and
      result = getResultAst(r.(Raw::WhileStmt).getCondition())
    )
  }

  final override StmtBlock getBody() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, whileStmtBody(), result)
      or
      not synthChild(r, whileStmtBody(), _) and
      result = getResultAst(r.(Raw::WhileStmt).getBody())
    )
  }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = whileStmtCond() and
    result = this.getCondition()
    or
    i = whileStmtBody() and
    result = this.getBody()
  }
}
