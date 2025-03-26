private import Raw

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
  override SourceLocation getLocation() { command_location(this, result) }

  final override Ast getChild(ChildIndex i) {
    exists(int index |
      i = CmdElement_(index) and
      result = this.getElement(index)
      or
      i = CmdRedirection(index) and
      result = this.getRedirection(index)
    )
  }

  // TODO: This only make sense for some commands (e.g., not dot-sourcing)
  CmdElement getCallee() { result = this.getElement(0) }

  /** Gets the name of the command without any qualifiers. */
  string getCommandName() { parseCommandName(this, _, result) }

  /** Holds if the command is qualified. */
  predicate isQualified() { parseCommandName(this, any(string s | s != ""), _) }

  /** Gets the (possibly qualified) name of this command. */
  string getQualifiedCommandName() { command(this, result, _, _, _) }

  int getKind() { command(this, _, result, _, _) }

  int getNumElements() { command(this, _, _, result, _) }

  int getNumRedirection() { command(this, _, _, _, result) }

  CmdElement getElement(int i) { command_command_element(this, i, result) }

  /** Gets the expression that determines the command to invoke. */
  Expr getCommand() { result = this.getElement(0) }

  Redirection getRedirection(int i) { command_redirection(this, i, result) }

  Redirection getARedirection() { result = this.getRedirection(_) }

  Expr getArgument(int i) {
    result =
      rank[i + 1](CmdElement e, Expr r, int j |
        (
          // For most commands the 0'th element is the command name ...
          j > 0
          or
          // ... but for certain commands (such as the call operator or the dot-
          // sourcing operator) the 0'th element is not the command name, but
          // rather the thing to invoke. These all appear to be commands with
          // an empty string as the command name.
          this.getCommandName() = ""
        ) and
        e = this.getElement(j) and
        (
          not e instanceof CmdParameter and
          r = e
          or
          r = e.(CmdParameter).getExpr()
        )
      |
        r order by j
      )
  }

  Expr getNamedArgument(string name) {
    exists(CmdParameter p, int index |
      result = this.getArgument(index) and
      p.getName() = name
    |
      p.getExpr() = result
      or
      exists(int jndex |
        not exists(p.getExpr()) and
        this.getElement(jndex) = p and
        this.getElement(jndex + 1) = result
      )
    )
  }
}

/** A call to operator `&`. */
class CallOperator extends Cmd {
  CallOperator() { this.getKind() = 28 }
}

/** A call to the dot-sourcing `.`. */
class DotSourcingOperator extends Cmd {
  DotSourcingOperator() { this.getKind() = 35 }
}
