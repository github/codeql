private import AstImport

class ReturnStmt extends Stmt, TReturnStmt {
  override string toString() {
    if this.hasPipeline() then result = "return ..." else result = "return"
  }

  override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = returnStmtPipeline() and
    result = this.getPipeline()
  }

  predicate hasPipeline() { exists(this.getPipeline()) }

  Expr getPipeline() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, returnStmtPipeline(), result)
      or
      not synthChild(r, returnStmtPipeline(), _) and
      result = getResultAst(r.(Raw::ReturnStmt).getPipeline())
    )
  }
}
