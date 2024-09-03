import powershell

class UnaryExpr extends @unary_expression, Expr {
  override SourceLocation getLocation() { unary_expression_location(this, result) }

  int getKind() { unary_expression(this, _, result, _) }

  Expr getOperand() { unary_expression(this, result, _, _) }
}

class NotExpr extends UnaryExpr {
  NotExpr() { this.getKind() = 36 }

  final override string toString() { result = "!..." }
}
