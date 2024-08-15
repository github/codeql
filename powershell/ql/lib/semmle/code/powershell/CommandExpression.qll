import powershell

class CommandExpression extends @command_expression, CommandBase {
  override SourceLocation getLocation() { command_expression_location(this, result) }

  Expression getExpression() { command_expression(this, result, _) }

  int getNumRedirections() { command_expression(this, _, result) }

  Redirection getRedirection(int i) { command_expression_redirection(this, i, result) }

  Redirection getARedirection() { result = this.getRedirection(_) }

  override string toString() { result = "CommandExpression at: " + this.getLocation().toString() }
}
