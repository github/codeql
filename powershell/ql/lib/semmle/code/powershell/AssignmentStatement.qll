import powershell

class AssignStmt extends @assignment_statement, PipelineBase {
  override SourceLocation getLocation() { assignment_statement_location(this, result) }

  int getKind() { assignment_statement(this, result, _, _) }

  Expr getLeftHandSide() { assignment_statement(this, _, result, _) }

  Stmt getRightHandSide() { assignment_statement(this, _, _, result) }

  override string toString() { result = "...=..." }
}
