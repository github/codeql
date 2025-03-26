private import Raw

class ForStmt extends @for_statement, LoopStmt {
  override SourceLocation getLocation() { for_statement_location(this, result) }

  PipelineBase getInitializer() { for_statement_initializer(this, result) }

  PipelineBase getCondition() { for_statement_condition(this, result) }

  PipelineBase getIterator() { for_statement_iterator(this, result) }

  final override StmtBlock getBody() { for_statement(this, result) }

  final override Ast getChild(ChildIndex i) {
    i = ForStmtInit() and
    result = this.getInitializer()
    or
    i = ForStmtCond() and
    result = this.getCondition()
    or
    i = ForStmtIter() and
    result = this.getIterator()
    or
    i = ForStmtBody() and
    result = this.getBody()
  }
}
