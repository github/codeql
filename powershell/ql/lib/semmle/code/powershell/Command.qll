import powershell

class Cmd extends @command, CmdBase {
  override string toString() { result = this.getName() }

  override SourceLocation getLocation() { command_location(this, result) }

  string getName() { command(this, result, _, _, _) }

  int getKind() { command(this, _, result, _, _) }

  int getNumElements() { command(this, _, _, result, _) }

  int getNumRedirection() { command(this, _, _, _, result) }

  CmdElement getElement(int i) { command_command_element(this, i, result) }

  Redirection getRedirection(int i) { command_redirection(this, i, result) }

  CmdElement getAnElement() { result = this.getElement(_) }

  Redirection getARedirection() { result = this.getRedirection(_) }
}
