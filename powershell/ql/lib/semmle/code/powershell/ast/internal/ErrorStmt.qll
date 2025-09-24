private import AstImport

/**
 * An error statement that occurs when parsing fails.
 */
class ErrorStmt extends Stmt, TErrorStmt {
  final override string toString() { result = "error" }
}
