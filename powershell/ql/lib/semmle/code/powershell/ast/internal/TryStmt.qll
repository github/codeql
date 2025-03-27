private import AstImport

class TryStmt extends Stmt, TTryStmt {
  CatchClause getCatchClause(int i) {
    exists(ChildIndex index, Raw::Ast r | index = tryStmtCatchClause(i) and r = getRawAst(this) |
      synthChild(r, index, result)
      or
      not synthChild(r, index, _) and
      result = getResultAst(r.(Raw::TryStmt).getCatchClause(i))
    )
  }

  CatchClause getACatchClause() { result = this.getCatchClause(_) }

  /** ..., if any. */
  StmtBlock getFinally() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, tryStmtFinally(), result)
      or
      not synthChild(r, tryStmtFinally(), _) and
      result = getResultAst(r.(Raw::TryStmt).getFinally())
    )
  }

  predicate hasFinally() { exists(this.getFinally()) }

  StmtBlock getBody() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, tryStmtBody(), result)
      or
      not synthChild(r, tryStmtBody(), _) and
      result = getResultAst(r.(Raw::TryStmt).getBody())
    )
  }

  override string toString() { result = "try {...}" }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = tryStmtBody() and
    result = this.getBody()
    or
    exists(int index |
      i = tryStmtCatchClause(index) and
      result = this.getCatchClause(index)
    )
    or
    i = tryStmtFinally() and
    result = this.getFinally()
  }
}
