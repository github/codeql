import powershell

class WhileStmt extends @while_statement, LoopStmt {
  override SourceLocation getLocation() { while_statement_location(this, result) }

  override string toString() { result = "while(...) {...}" }

  PipelineBase getCondition() { while_statement_condition(this, result) } // TODO: Change @ast to @pipeline_base in dbscheme

  final override StmtBlock getBody() { while_statement(this, result) } // TODO: Change @ast to @stmt_block in dbscheme
}
