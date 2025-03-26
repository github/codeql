private import AstImport

class BreakStmt extends GotoStmt, TBreakStmt {
  override string toString() { result = "break" }
}
