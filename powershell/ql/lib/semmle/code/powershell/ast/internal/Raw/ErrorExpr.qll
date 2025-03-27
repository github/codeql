private import Raw

class ErrorExpr extends @error_expression, Expr {
  final override SourceLocation getLocation() { error_expression_location(this, result) }
}
