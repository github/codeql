private import AstImport

/**
 * An expression statement. This statement is inserted in the AST when a
 * statement is required, but an expression is provided. For example in:
 * ```
 * function CallFoo($x) {
 *   $x.foo()
 * }
 * ```
 * The body of `CallFoo` is a statement, but `$x.foo()` is an expression. So
 * the first element in the body of `CallFoo` is an `ExprStmt`.
 */
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
