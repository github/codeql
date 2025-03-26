private import Raw

/** A `break` or `continue` statement. */
class GotoStmt extends @labelled_statement, Stmt {
  /** ..., if any. */
  Expr getLabel() { statement_label(this, result) }

  final override Ast getChild(ChildIndex i) { i = GotoStmtLabel() and result = this.getLabel() }
}
