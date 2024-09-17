import powershell

class Cmd extends @command, CmdBase {
  override string toString() { result = this.getName() }

  override SourceLocation getLocation() { command_location(this, result) }

  string getName() { command(this, result, _, _, _) }

  int getKind() { command(this, _, result, _, _) }

  int getNumElements() { command(this, _, _, result, _) }

  int getNumRedirection() { command(this, _, _, _, result) }

  CmdElement getElement(int i) { command_command_element(this, i, result) }

  Expr getCommand() { result = this.getElement(0) }

  StringConstExpr getCmdName() { result = this.getElement(0) }

  Expr getArgument(int i) {
    result =
      rank[i + 1](CmdElement e, int j |
        e = this.getElement(j) and
        not e instanceof CmdParameter and
        j > 0 // 0'th element is the command name itself
      |
        e order by j
      )
  }

  Expr getNamedArgument(string name) {
    exists(int i, CmdParameter p |
      this.getElement(i) = p and
      p.getName() = name and
      result = p.getArgument()
    )
  }

  Redirection getRedirection(int i) { command_redirection(this, i, result) }

  Redirection getARedirection() { result = this.getRedirection(_) }
}

/**
 * An argument to a command.
 *
 * The argument may be named or positional.
 */
class Argument extends Expr {
  Cmd cmd;

  Argument() { cmd.getArgument(_) = this or cmd.getNamedArgument(_) = this }

  Cmd getCmd() { result = cmd }

  int getIndex() { cmd.getArgument(result) = this }

  string getName() { cmd.getNamedArgument(result) = this }
}
