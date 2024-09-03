import powershell

class ForEachStmt extends @foreach_statement, LoopStmt {
  override SourceLocation getLocation() { foreach_statement_location(this, result) }

  override string toString() { result = "forach(... in ...)" }

  final override StmtBlock getBody() { foreach_statement(this, _, _, result, _) }

  VarAccess getVariable() { foreach_statement(this, result, _, _, _) }

  PipelineBase getIterableExpr() { foreach_statement(this, _, result, _, _) }

  predicate isParallel() { foreach_statement(this, _, _, _, 1) }
}
