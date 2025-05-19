private import AstImport

class ErrorExpr extends Expr, TErrorExpr {
  final override string toString() { result = "error" }
}
