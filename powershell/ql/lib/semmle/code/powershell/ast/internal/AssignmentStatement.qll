private import AstImport

class AssignStmt extends Stmt, TAssignStmt {
  Expr getRightHandSide() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, assignStmtRightHandSide(), result)
      or
      not synthChild(r, assignStmtRightHandSide(), _) and
      result = getResultAst(r.(Raw::AssignStmt).getRightHandSide())
    )
  }

  Expr getLeftHandSide() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, assignStmtLeftHandSide(), result)
      or
      not synthChild(r, assignStmtLeftHandSide(), _) and
      result = getResultAst(r.(Raw::AssignStmt).getLeftHandSide())
    )
  }

  override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = assignStmtLeftHandSide() and
    result = this.getLeftHandSide()
    or
    i = assignStmtRightHandSide() and
    result = this.getRightHandSide()
  }

  override string toString() { result = "...=..." }
}
