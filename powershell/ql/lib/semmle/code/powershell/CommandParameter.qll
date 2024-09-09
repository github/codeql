import powershell

class CmdParameter extends @command_parameter, CmdElement {
  override SourceLocation getLocation() { command_parameter_location(this, result) }

  string getName() { command_parameter(this, result) }

  Expr getArgument() {
    // When an argumnt is of the form -Name:$var
    command_parameter_argument(this, result)
    or
    // When an argument is of the form -Name $var
    exists(int i, Cmd cmd |
      cmd = this.getCmd() and
      cmd.getElement(i) = this and
      result = cmd.getElement(i + 1)
    )
  }

  Cmd getCmd() { result.getElement(_) = this }

  override string toString() { command_parameter(this, result) }
}
