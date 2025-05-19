private import Raw

class CmdParameter extends @command_parameter, CmdElement {
  override SourceLocation getLocation() { command_parameter_location(this, result) }

  string getName() { command_parameter(this, result) }

  Ast getExpr() {
    command_parameter_argument(this, result)
  }

  Cmd getCmd() { result.getElement(_) = this }
}
