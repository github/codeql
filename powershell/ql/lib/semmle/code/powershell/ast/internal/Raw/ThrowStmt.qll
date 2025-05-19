private import Raw

class ThrowStmt extends @throw_statement, Stmt {
  override SourceLocation getLocation() { throw_statement_location(this, result) }

  PipelineBase getPipeline() { throw_statement_pipeline(this, result) }

  predicate hasPipeline() { exists(this.getPipeline()) }

  final override Ast getChild(ChildIndex i) { i = ThrowStmtPipeline() and result = this.getPipeline() }
}
