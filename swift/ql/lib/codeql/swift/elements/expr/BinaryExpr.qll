private import codeql.swift.generated.expr.BinaryExpr
private import codeql.swift.elements.expr.Expr

class BinaryExpr extends BinaryExprBase {
  Expr getLeftOperand() { result = this.getArgument(0).getExpr() }

  Expr getRightOperand() { result = this.getArgument(1).getExpr() }

  Expr getAnOperand() { result = [this.getLeftOperand(), this.getRightOperand()] }

  override string toString() { result = "... " + this.getFunction().toString() + " ..." }
}
