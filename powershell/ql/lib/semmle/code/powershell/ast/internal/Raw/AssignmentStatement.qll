private import Raw

class AssignStmt extends @assignment_statement, PipelineBase {
  override SourceLocation getLocation() { assignment_statement_location(this, result) }

  int getKind() { assignment_statement(this, result, _, _) }

  Expr getLeftHandSide() { assignment_statement(this, _, result, _) }

  Stmt getRightHandSide() { assignment_statement(this, _, _, result) }

  final override Ast getChild(ChildIndex i) {
    i = AssignStmtLeftHandSide() and
    result = this.getLeftHandSide()
    or
    i = AssignStmtRightHandSide() and
    result = this.getRightHandSide()
  }
}
