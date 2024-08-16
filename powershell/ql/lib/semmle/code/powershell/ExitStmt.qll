import powershell

class ExitStmt extends @exit_statement, Stmt {
  override SourceLocation getLocation() { exit_statement_location(this, result) }

  override string toString() { if this.hasPipeline() then result = "exit ..." else result = "exit" }

  /** ..., if any. */
  PipelineBase getPipeline() { exit_statement_pipeline(this, result) } // TODO: Change @ast to @pipeline_base in dbscheme

  predicate hasPipeline() { exists(this.getPipeline()) }
}
