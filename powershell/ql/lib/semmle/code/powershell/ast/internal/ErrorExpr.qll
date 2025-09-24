private import AstImport

/**
 * An error expression that occurs when parsing fails.
 */
class ErrorExpr extends Expr, TErrorExpr {
  final override string toString() { result = "error" }
}
