private import Raw

class WhileStmt extends @while_statement, LoopStmt {
  override SourceLocation getLocation() { while_statement_location(this, result) }

  PipelineBase getCondition() { while_statement_condition(this, result) }

  final override StmtBlock getBody() { while_statement(this, result) }

  final override Ast getChild(ChildIndex i) {
    i = WhileStmtCond() and result = this.getCondition()
    or
    i = WhileStmtBody() and result = this.getBody()
  }
}
