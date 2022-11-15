private import codeql.swift.generated.expr.BinaryExpr
private import codeql.swift.elements.expr.Expr
private import codeql.swift.elements.decl.AbstractFunctionDecl

class BinaryExpr extends Generated::BinaryExpr {
  Expr getLeftOperand() { result = this.getArgument(0).getExpr() }

  Expr getRightOperand() { result = this.getArgument(1).getExpr() }

  AbstractFunctionDecl getOperator() { result = this.getStaticTarget() }

  Expr getAnOperand() { result = [this.getLeftOperand(), this.getRightOperand()] }

  override string toString() { result = "... " + this.getFunction().toString() + " ..." }
}
