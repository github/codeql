import powershell

class BinaryExpr extends @binary_expression, Expr {
  override string toString() {
    result = "...+..." // TODO
  }

  override SourceLocation getLocation() { binary_expression_location(this, result) }

  private int getKind() { binary_expression(this, result, _, _) }

  Expr getLeft() { binary_expression(this, _, result, _) }

  Expr getRight() { binary_expression(this, _, _, result) }
}
