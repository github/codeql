private import AstImport

/**
 * A break statement. For example:
 * ```
 * break
 * ```
 */
class BreakStmt extends GotoStmt, TBreakStmt {
  override string toString() { result = "break" }
}
