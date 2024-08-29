import powershell

class ForStmt extends @for_statement, LoopStmt {
  override SourceLocation getLocation() { for_statement_location(this, result) }

  override string toString() { result = "for(...;...;...)" }

  PipelineBase getInitializer() { for_statement_initializer(this, result) } // TODO: Change @ast to @pipeline_base in dbscheme

  PipelineBase getCondition() { for_statement_condition(this, result) } // TODO: Change @ast to @pipeline_base in dbscheme

  PipelineBase getIterator() { for_statement_iterator(this, result) } // TODO: Change @ast to @pipeline_base in dbscheme

  final override StmtBlock getBody() { for_statement(this, result) } // TODO: Change @ast to @stmt_block in dbscheme
}
