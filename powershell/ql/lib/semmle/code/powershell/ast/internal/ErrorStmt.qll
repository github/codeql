private import AstImport

class ErrorStmt extends Stmt, TErrorStmt {
  final override string toString() { result = "error" }
}
