import powershell

class ForEachStmt extends @foreach_statement, LoopStmt {
  override SourceLocation getLocation() { foreach_statement_location(this, result) }

  override string toString() { result = "forach(... in ...)" }

  final override StmtBlock getBody() { foreach_statement(this, _, _, result, _) } // TODO: Change @ast to @stmt_block in dbscheme

  VarAccess getVariable() { foreach_statement(this, result, _, _, _) } // TODO: Change @ast to @variable_expression in dbscheme

  /** ..., if any. */
  PipelineBase getCondition() { foreach_statement(this, _, result, _, _) } // TODO: Change @ast to @pipeline_base in dbscheme

  predicate isParallel() { foreach_statement(this, _, _, _, 1) }
}
