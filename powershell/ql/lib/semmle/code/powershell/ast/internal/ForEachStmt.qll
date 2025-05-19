private import AstImport

class ForEachStmt extends LoopStmt, TForEachStmt {
  override string toString() { result = "forach(... in ...)" }

  final override StmtBlock getBody() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, forEachStmtBody(), result)
      or
      not synthChild(r, forEachStmtBody(), _) and
      result = getResultAst(r.(Raw::ForEachStmt).getBody())
    )
  }

  // TODO: Should this API change?
  VarAccess getVarAccess() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, forEachStmtVar(), result)
      or
      not synthChild(r, forEachStmtVar(), _) and
      result = getResultAst(r.(Raw::ForEachStmt).getVarAccess())
    )
  }

  Expr getIterableExpr() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, forEachStmtIter(), result)
      or
      not synthChild(r, forEachStmtIter(), _) and
      result = getResultAst(r.(Raw::ForEachStmt).getIterableExpr())
    )
  }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = forEachStmtVar() and result = this.getVarAccess()
    or
    i = forEachStmtIter() and result = this.getIterableExpr()
    or
    i = forEachStmtBody() and result = this.getBody()
  }
}
