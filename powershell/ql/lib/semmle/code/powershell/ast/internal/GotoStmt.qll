private import AstImport

class GotoStmt extends Stmt, TGotoStmt {
  Expr getLabel() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, gotoStmtLabel(), result)
      or
      not synthChild(r, gotoStmtLabel(), _) and
      result = getResultAst(r.(Raw::GotoStmt).getLabel())
    )
  }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = gotoStmtLabel() and result = this.getLabel()
  }
}
