private import Raw

class ForEachStmt extends @foreach_statement, LoopStmt {
  override SourceLocation getLocation() { foreach_statement_location(this, result) }

  final override StmtBlock getBody() { foreach_statement(this, _, _, result, _) }

  VarAccess getVarAccess() { foreach_statement(this, result, _, _, _) }

  PipelineBase getIterableExpr() { foreach_statement(this, _, result, _, _) }

  predicate isParallel() { foreach_statement(this, _, _, _, 1) }

  final override Ast getChild(ChildIndex i) {
    i = ForEachStmtVar() and result = this.getVarAccess()
    or
    i = ForEachStmtIter() and result = this.getIterableExpr()
    or
    i = ForEachStmtBody() and result = this.getBody()
  }
}
