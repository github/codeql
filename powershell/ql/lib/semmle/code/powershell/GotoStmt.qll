import powershell

/** A `break` or `continue` statement. */
class GotoStmt extends @labelled_statement, Stmt {

  /** ..., if any. */
  Expr getLabel() { statement_label(this, result) }
}
