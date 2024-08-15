import powershell

class CommandParameter extends @command_parameter, CommandElement {
  override SourceLocation getLocation() { command_parameter_location(this, result) }

  string getName() { command_parameter(this, result) }

  Expression getArgument() { command_parameter_argument(this, result) }

  override string toString() { command_parameter(this, result) }
}
