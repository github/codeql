private import Raw

class ReturnStmt extends @return_statement, Stmt {
  override SourceLocation getLocation() { return_statement_location(this, result) }

  PipelineBase getPipeline() { return_statement_pipeline(this, result) }

  predicate hasPipeline() { exists(this.getPipeline()) }

  final override Ast getChild(ChildIndex i) { i = ReturnStmtPipeline() and result = this.getPipeline() }
}
