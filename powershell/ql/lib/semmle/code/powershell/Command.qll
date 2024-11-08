import powershell

private predicate parseCommandName(Cmd cmd, string namespace, string name) {
  exists(string qualified | command(cmd, qualified, _, _, _) |
    namespace = qualified.regexpCapture("([^\\\\]+)\\\\([^\\\\]+)", 1) and
    name = qualified.regexpCapture("([^\\\\]+)\\\\([^\\\\]+)", 2)
    or
    // Not a qualified name
    not exists(qualified.indexOf("\\")) and
    namespace = "" and
    name = qualified
  )
}

/** A call to a command. */
class Cmd extends @command, CmdBase {
  override string toString() { result = "call to " + this.getQualifiedCommandName() }

  override SourceLocation getLocation() { command_location(this, result) }

  /** Gets the name of the command without any qualifiers. */
  string getCommandName() { parseCommandName(this, _, result) }

  /** Holds if the command is qualified. */
  predicate isQualified() { parseCommandName(this, any(string s | s != ""), _) }

  /** Gets the namespace qualifier of this command, if any. */
  string getNamespaceQualifier() { parseCommandName(this, result, _) }

  /** Gets the (possibly qualified) name of this command. */
  string getQualifiedCommandName() { command(this, result, _, _, _) }

  int getKind() { command(this, _, result, _, _) }

  int getNumElements() { command(this, _, _, result, _) }

  int getNumRedirection() { command(this, _, _, _, result) }

  CmdElement getElement(int i) { command_command_element(this, i, result) }

  /** Gets the expression that determines the command to invoke. */
  Expr getCommand() { result = this.getElement(0) }

  /** Gets the name of this command, if this is statically known. */
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

  /** Holds if this call has an argument named `name`. */
  predicate hasNamedArgument(string name) { exists(this.getNamedArgument(name)) }

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

/** A call to operator `&`. */
class CallOperator extends Cmd {
  CallOperator() { this.getKind() = 28 }
}
