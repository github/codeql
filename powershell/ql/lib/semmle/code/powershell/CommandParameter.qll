import powershell

class CmdParameter extends @command_parameter, CmdElement {
  override SourceLocation getLocation() { command_parameter_location(this, result) }

  string getName() { command_parameter(this, result) }

  Expr getArgument() { command_parameter_argument(this, result) }

  override string toString() { command_parameter(this, result) }
}
