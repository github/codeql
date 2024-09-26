import powershell

class Cmd extends @command, CmdBase {
  override string toString() { result = this.getCommandName() }

  override SourceLocation getLocation() { command_location(this, result) }

  string getCommandName() { command(this, result, _, _, _) }

  int getKind() { command(this, _, result, _, _) }

  int getNumElements() { command(this, _, _, result, _) }

  int getNumRedirection() { command(this, _, _, _, result) }

  CmdElement getElement(int i) { command_command_element(this, i, result) }

  Expr getCommand() { result = this.getElement(0) }

  StringConstExpr getCmdName() { result = this.getElement(0) }

  /** Gets any argument to this command. */
  Expr getAnArgument() { result = this.getArgument(_) }

  /**
   * Gets the `i`th argument to this command.
   *
   * The argument may be named or positional.
   */
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

  /** Gets the `i`th positional argument to this command. */
  Expr getPositionalArgument(int i) {
    result =
      rank[i + 1](Argument e, int j |
        e = this.getArgument(j) and
        e instanceof PositionalArgument
      |
        e order by j
      )
  }

  /** Gets the named argument with the given name. */
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

  Argument() { cmd.getAnArgument() = this }

  Cmd getCmd() { result = cmd }

  int getPosition() { cmd.getPositionalArgument(result) = this }

  string getName() { cmd.getNamedArgument(result) = this }
}

/** A positional argument to a command. */
class PositionalArgument extends Argument {
  PositionalArgument() { not this instanceof NamedArgument }
}

/** A named argument to a command. */
class NamedArgument extends Argument {
  NamedArgument() { this = cmd.getNamedArgument(_) }
}
