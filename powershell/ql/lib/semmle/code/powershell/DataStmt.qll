import powershell

class DataStmt extends @data_statement, Stmt {
  override SourceLocation getLocation() { data_statement_location(this, result) }

  override string toString() { result = "data {...}" }

  string getVariableName() { data_statement_variable(this, result) }

  Expr getCmdAllowed(int i) { data_statement_commands_allowed(this, i, result) }

  Expr getACmdAllowed() { result = this.getCmdAllowed(_) }

  StmtBlock getBody() { data_statement(this, result) } // TODO: Change @ast to @stmt_block in dbscheme
}
