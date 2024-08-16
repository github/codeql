import powershell

/** A `break` or `continue` statement. */
class GotoStmt extends @labelled_statement, Stmt { // TODO: Rename @labelled_statement to @goto_statement

  /** ..., if any. */
  Expr getLabel() { statement_label(this, result) } // TODO: Replace @ast with @expression
}
