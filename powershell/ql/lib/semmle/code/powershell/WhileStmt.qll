import powershell

class WhileStmt extends @while_statement, LoopStmt {
  override SourceLocation getLocation() { while_statement_location(this, result) }

  override string toString() { result = "while(...) {...}" }

  PipelineBase getCondition() { while_statement_condition(this, result) }

  final override StmtBlock getBody() { while_statement(this, result) }
}
