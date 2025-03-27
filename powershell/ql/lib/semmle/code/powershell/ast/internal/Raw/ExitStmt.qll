private import Raw

class ExitStmt extends @exit_statement, Stmt {
  override SourceLocation getLocation() { exit_statement_location(this, result) }

  /** ..., if any. */
  PipelineBase getPipeline() { exit_statement_pipeline(this, result) }

  predicate hasPipeline() { exists(this.getPipeline()) }

  final override Ast getChild(ChildIndex i) {
    i = ExitStmtPipeline() and result = this.getPipeline()
  }
}
