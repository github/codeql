import powershell

class ForStmt extends @for_statement, LoopStmt {
  override SourceLocation getLocation() { for_statement_location(this, result) }

  override string toString() { result = "for(...;...;...)" }

  PipelineBase getInitializer() { for_statement_initializer(this, result) }

  PipelineBase getCondition() { for_statement_condition(this, result) }

  PipelineBase getIterator() { for_statement_iterator(this, result) }

  final override StmtBlock getBody() { for_statement(this, result) }
}
