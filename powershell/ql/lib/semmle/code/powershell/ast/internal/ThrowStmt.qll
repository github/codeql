private import AstImport

/**
 * A throw statement. For example:
 * ```
 * throw "An error occurred"
 * throw [System.ArgumentException]::new("Invalid argument")
 * throw
 * ```
 */
class ThrowStmt extends Stmt, TThrowStmt {
  Expr getPipeline() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, throwStmtPipeline(), result)
      or
      not synthChild(r, throwStmtPipeline(), _) and
      result = getResultAst(r.(Raw::ThrowStmt).getPipeline())
    )
  }

  predicate hasPipeline() { exists(this.getPipeline()) }

  override string toString() {
    if this.hasPipeline() then result = "throw ..." else result = "throw"
  }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = throwStmtPipeline() and result = this.getPipeline()
  }
}
