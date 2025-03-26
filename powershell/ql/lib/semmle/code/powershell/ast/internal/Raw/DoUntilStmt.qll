private import Raw

class DoUntilStmt extends @do_until_statement, LoopStmt {
  override SourceLocation getLocation() { do_until_statement_location(this, result) }

  PipelineBase getCondition() { do_until_statement_condition(this, result) }

  final override StmtBlock getBody() { do_until_statement(this, result) }

  final override Ast getChild(ChildIndex i) {
    i = DoUntilStmtCond() and
    result = this.getCondition()
    or
    i = DoUntilStmtBody() and
    result = this.getBody()
  }
}
