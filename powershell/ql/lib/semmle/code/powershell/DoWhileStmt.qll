import powershell

class DoWhileStmt extends @do_while_statement, LoopStmt {
  override SourceLocation getLocation() { do_while_statement_location(this, result) }

  override string toString() { result = "DoWhile" }

  PipelineBase getCondition() { do_while_statement_condition(this, result) } // TODO: Change @ast to @pipeline_base in dbscheme

  final override StmtBlock getBody() { do_while_statement(this, result) } // TODO: Change @ast to @stmt_block in dbscheme
}
