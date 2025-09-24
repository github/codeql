private import AstImport

/**
 * A continue statement. For example:
 * ```
 * continue
 * ```
 */
class ContinueStmt extends Stmt, TContinueStmt {
  override string toString() { result = "continue" }
}
