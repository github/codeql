private import AstImport

class ExprStmt extends Stmt, TExprStmt {
  override string toString() { result = "[Stmt] " + this.getExpr().toString() }

  string getName() { result = any(Synthesis s).toString(this) }

  override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = exprStmtExpr() and
    result = this.getExpr()
  }

  Expr getExpr() { any(Synthesis s).exprStmtExpr(this, result) }
}
