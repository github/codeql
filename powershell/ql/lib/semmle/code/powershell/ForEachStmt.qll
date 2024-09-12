import powershell

class ForEachStmt extends @foreach_statement, LoopStmt {
  override SourceLocation getLocation() { foreach_statement_location(this, result) }

  override string toString() { result = "forach(... in ...)" }

  final override StmtBlock getBody() { foreach_statement(this, _, _, result, _) }

  VarAccess getVarAccess() { foreach_statement(this, result, _, _, _) }

  Variable getVariable() {
    exists(VarAccess va |
      va = this.getVarAccess() and
      foreach_statement(this, va, _, _, _) and
      result = va.getVariable()
    )
  }

  PipelineBase getIterableExpr() { foreach_statement(this, _, result, _, _) }

  predicate isParallel() { foreach_statement(this, _, _, _, 1) }
}
