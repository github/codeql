import powershell

class DynamicStmt extends @dynamic_keyword_statement, Stmt {
  override SourceLocation getLocation() { dynamic_keyword_statement_location(this, result) }

  override string toString() { result = "&..." }

  CmdElement getCmd(int i) { dynamic_keyword_statement_command_elements(this, i, result) }

  CmdElement getACmd() { result = this.getCmd(_) }
}
