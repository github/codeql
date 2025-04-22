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

  /**
   * Gets the `i`th argument to this command.
   *
   * This is either an expression, or a CmdParameter with no expression.
   * The latter is only used to denote switch parameters.
   */
  CmdElement getArgument(int i) {
    result =
      rank[i + 1](CmdElement e, CmdElement r, int j |
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
          exists(CmdParameter p | e = p |
            // If it has an expression, use that
            p.getExpr() = r
            or
            // Otherwise, if it doesn't have an expression it's either
            // because it's of the form (1) `-Name x`, (2) `-Name -SomethingElse`,
            // or (3) `-Name` (with no other elements).
            // In (1) we use `x` as the argument, and in (2) and (3) we use
            // `-Name` as the argument.
            not exists(p.getExpr()) and
            (
              this.getElement(j + 1) instanceof CmdParameter and
              p = r
              or
              // Case 3
              not exists(this.getElement(j + 1)) and
              r = p
            )
          )
        )
      |
        r order by j
      )
  }

  Expr getNamedArgument(string name) {
    exists(CmdParameter p, int index |
      p = this.getElement(index) and
      p.getName().toLowerCase() = name
    |
      result = p.getExpr()
      or
      not exists(p.getExpr()) and
      // `not result instanceof CmdParameter` is implied
      result = this.getElement(index + 1)
    )
  }

  CmdParameter getSwitchArgument(string name) {
    not exists(this.getNamedArgument(name)) and
    exists(int index |
      result = this.getElement(index) and
      result.getName().toLowerCase() = name and
      not exists(result.getExpr())
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
