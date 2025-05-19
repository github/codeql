private import Raw

class DataStmt extends @data_statement, Stmt {
  override SourceLocation getLocation() { data_statement_location(this, result) }

  string getVariableName() { data_statement_variable(this, result) }

  Expr getCmdAllowed(int i) { data_statement_commands_allowed(this, i, result) }

  Expr getACmdAllowed() { result = this.getCmdAllowed(_) }

  StmtBlock getBody() { data_statement(this, result) }

  final override Ast getChild(ChildIndex i) {
    i = DataStmtBody() and
    result = this.getBody()
    or
    exists(int index |
      i = DataStmtCmdAllowed(index) and
      result = this.getCmdAllowed(index)
    )
  }
}
