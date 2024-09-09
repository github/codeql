import powershell

class DoUntilStmt extends @do_until_statement, LoopStmt {
  override SourceLocation getLocation() { do_until_statement_location(this, result) }

  override string toString() { result = "DoUntil" }

  PipelineBase getCondition() { do_until_statement_condition(this, result) }

  final override StmtBlock getBody() { do_until_statement(this, result) }
}
