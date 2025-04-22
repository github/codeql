private import AstImport

class DataStmt extends Stmt, TDataStmt {
  override string toString() { result = "data {...}" }

  Expr getCmdAllowed(int i) {
    exists(ChildIndex index, Raw::Ast r | index = dataStmtCmdAllowed(i) and r = getRawAst(this) |
      synthChild(r, index, result)
      or
      not synthChild(r, index, _) and
      result = getResultAst(r.(Raw::DataStmt).getCmdAllowed(i))
    )
  }

  Expr getACmdAllowed() { result = this.getCmdAllowed(_) }

  StmtBlock getBody() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, dataStmtBody(), result)
      or
      not synthChild(r, dataStmtBody(), _) and
      result = getResultAst(r.(Raw::DataStmt).getBody())
    )
  }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = dataStmtBody() and
    result = this.getBody()
    or
    exists(int index |
      i = dataStmtCmdAllowed(index) and
      result = this.getCmdAllowed(index)
    )
  }
}
