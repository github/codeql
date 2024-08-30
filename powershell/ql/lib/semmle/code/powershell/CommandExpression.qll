import powershell

class CmdExpr extends @command_expression, CmdBase {
  override SourceLocation getLocation() { command_expression_location(this, result) }

  Expr getExpr() { command_expression(this, result, _) }

  int getNumRedirections() { command_expression(this, _, result) }

  Redirection getRedirection(int i) { command_expression_redirection(this, i, result) }

  Redirection getARedirection() { result = this.getRedirection(_) }

  override string toString() { result = this.getExpr().toString() }
}
