import powershell

class ReturnStmt extends @return_statement, Stmt {
  override SourceLocation getLocation() { return_statement_location(this, result) }

  override string toString() {
    if this.hasPipeline() then result = "return ..." else result = "return"
  }

  PipelineBase getPipeline() { return_statement_pipeline(this, result) } // TODO: Change @ast to @pipeline_base in dbscheme

  predicate hasPipeline() { exists(this.getPipeline()) }
}
