private import Raw

class DoWhileStmt extends @do_while_statement, LoopStmt {
  override SourceLocation getLocation() { do_while_statement_location(this, result) }

  PipelineBase getCondition() { do_while_statement_condition(this, result) }

  final override StmtBlock getBody() { do_while_statement(this, result) }

  final override Ast getChild(ChildIndex i) {
    i = DoWhileStmtCond() and
    result = this.getCondition()
    or
    i = DoWhileStmtBody() and
    result = this.getBody()
  }
}
