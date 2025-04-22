private import AstImport

class SwitchStmt extends Stmt, TSwitchStmt {
  final override string toString() { result = "switch(...) {...}" }

  Expr getCondition() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, switchStmtCond(), result)
      or
      not synthChild(r, switchStmtCond(), _) and
      result = getResultAst(r.(Raw::SwitchStmt).getCondition())
    )
  }

  StmtBlock getDefault() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, switchStmtDefault(), result)
      or
      not synthChild(r, switchStmtDefault(), _) and
      result = getResultAst(r.(Raw::SwitchStmt).getDefault())
    )
  }

  StmtBlock getCase(int i) {
    exists(ChildIndex index, Raw::Ast r | index = switchStmtCase(i) and r = getRawAst(this) |
      synthChild(r, index, result)
      or
      not synthChild(r, index, _) and
      result = getResultAst(r.(Raw::SwitchStmt).getCase(i))
    )
  }

  StmtBlock getACase() { result = this.getCase(_) }

  int getNumberOfCases() { result = getRawAst(this).(Raw::SwitchStmt).getNumberOfCases() }

  Expr getPattern(int i) {
    exists(ChildIndex index, Raw::Ast r | index = switchStmtPat(i) and r = getRawAst(this) |
      synthChild(r, index, result)
      or
      not synthChild(r, index, _) and
      result = getResultAst(r.(Raw::SwitchStmt).getPattern(i))
    )
  }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = switchStmtCond() and
    result = this.getCondition()
    or
    i = switchStmtDefault() and
    result = this.getDefault()
    or
    exists(int index |
      i = switchStmtCase(index) and
      result = this.getCase(index)
      or
      i = switchStmtPat(index) and
      result = this.getPattern(index)
    )
  }

  Expr getAPattern() { result = this.getPattern(_) }
}
