import powershell

/**
 * An expression.
 *
 * This is the topmost class in the hierachy of all expression in PowerShell.
 */
class Expr extends @expression, CmdElement {
  /** Gets the constant value of this expression, if this is known. */
  final ConstantValue getValue() { result.getAnExpr() = this }
}
