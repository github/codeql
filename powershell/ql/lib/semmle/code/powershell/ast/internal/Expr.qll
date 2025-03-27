private import AstImport

/**
 * An expression.
 *
 * This is the topmost class in the hierachy of all expression in PowerShell.
 */
class Expr extends Ast, TExpr {
  /** Gets the constant value of this expression, if this is known. */
  ConstantValue getValue() { result.getAnExpr() = this }

  Redirection getRedirection(int i) { synthChild(getRawAst(this), exprRedirection(i), result) }

  override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    exists(int index |
      i = exprRedirection(index) and
      result = this.getRedirection(index)
    )
  }
}
