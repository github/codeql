private import AstImport

class If extends Expr, TIf {
  override string toString() {
    if this.hasElse() then result = "if (...) {...} else {...}" else result = "if (...) {...}"
  }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = ifStmtElse() and
    result = this.getElse()
    or
    exists(int index |
      i = ifStmtCond(index) and
      result = this.getCondition(index)
      or
      i = ifStmtThen(index) and
      result = this.getThen(index)
    )
  }

  Expr getCondition(int i) {
    exists(ChildIndex index, Raw::Ast r | index = ifStmtCond(i) and r = getRawAst(this) |
      synthChild(r, index, result)
      or
      not synthChild(r, index, _) and
      result = getResultAst(r.(Raw::IfStmt).getCondition(i))
    )
  }

  Expr getACondition() { result = this.getCondition(_) }

  int getNumberOfConditions() { result = count(this.getACondition()) }

  StmtBlock getThen(int i) {
    exists(ChildIndex index, Raw::Ast r | index = ifStmtThen(i) and r = getRawAst(this) |
      synthChild(r, index, result)
      or
      not synthChild(r, index, _) and
      result = getResultAst(r.(Raw::IfStmt).getThen(i))
    )
  }

  StmtBlock getAThen() { result = this.getThen(_) }

  StmtBlock getElse() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, ifStmtElse(), result)
      or
      not synthChild(r, ifStmtElse(), _) and
      result = getResultAst(r.(Raw::IfStmt).getElse())
    )
  }

  predicate hasElse() { exists(this.getElse()) }
}
