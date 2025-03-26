private import AstImport

class ForStmt extends LoopStmt, TForStmt {
  override string toString() { result = "for(...;...;...)" }

  Ast getInitializer() {
    exists(Raw::Ast r | r = getRawAst(this) |
      // TODO: I think this is always an assignment?
      synthChild(r, forStmtInit(), result)
      or
      not synthChild(r, forStmtInit(), _) and
      result = getResultAst(r.(Raw::ForStmt).getInitializer())
    )
  }

  Expr getCondition() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, forStmtCond(), result)
      or
      not synthChild(r, forStmtCond(), _) and
      result = getResultAst(r.(Raw::ForStmt).getCondition())
    )
  }

  Ast getIterator() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, forStmtIter(), result)
      or
      not synthChild(r, forStmtIter(), _) and
      result = getResultAst(r.(Raw::ForStmt).getIterator())
    )
  }

  final override StmtBlock getBody() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, forStmtBody(), result)
      or
      not synthChild(r, forStmtBody(), _) and
      result = getResultAst(r.(Raw::ForStmt).getBody())
    )
  }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = forStmtInit() and
    result = this.getInitializer()
    or
    i = forStmtCond() and
    result = this.getCondition()
    or
    i = forStmtIter() and
    result = this.getIterator()
    or
    i = forStmtBody() and
    result = this.getBody()
  }
}
