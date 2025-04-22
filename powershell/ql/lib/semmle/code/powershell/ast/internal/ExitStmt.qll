private import AstImport

class ExitStmt extends Stmt, TExitStmt {
  Expr getPipeline() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, exitStmtPipeline(), result)
      or
      not synthChild(r, exitStmtPipeline(), _) and
      result = getResultAst(r.(Raw::ExitStmt).getPipeline())
    )
  }

  predicate hasPipeline() { exists(this.getPipeline()) }

  override string toString() { if this.hasPipeline() then result = "exit ..." else result = "exit" }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = exitStmtPipeline() and result = this.getPipeline()
  }
}
