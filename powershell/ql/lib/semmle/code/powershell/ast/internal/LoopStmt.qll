private import AstImport

/**
 * A statement that loops. For example, `for`, `foreach`, `while`, or `do` statements.
 */
class LoopStmt extends Stmt, TLoopStmt {
  StmtBlock getBody() { none() }
}
