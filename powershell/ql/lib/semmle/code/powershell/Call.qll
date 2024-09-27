import powershell

abstract private class AbstractCall extends Ast {
  abstract Expr getCommand();

  /** Gets the i'th argument to this call. */
  abstract Expr getArgument(int i);

  /** Gets the i'th positional argument to this call. */
  abstract Expr getPositionalArgument(int i);

  /** Gets the argument to this call with the name `name`. */
  abstract Expr getNamedArgument(string name);

  /** Gets any argument to this call. */
  final Expr getAnArgument() { result = this.getArgument(_) }

  /** Gets the qualifier of this call, if any. */
  Expr getQualifier() { none() }
}

private class CmdCall extends AbstractCall instanceof Cmd {
  final override Expr getCommand() { result = Cmd.super.getCommand() }

  final override Expr getPositionalArgument(int i) { result = Cmd.super.getPositionalArgument(i) }

  final override Expr getArgument(int i) { result = Cmd.super.getArgument(i) }

  final override Expr getNamedArgument(string name) { result = Cmd.super.getNamedArgument(name) }
}

private class InvokeMemberCall extends AbstractCall instanceof InvokeMemberExpr {
  final override Expr getCommand() { result = super.getMember() }

  final override Expr getPositionalArgument(int i) {
    result = InvokeMemberExpr.super.getArgument(i)
  }

  final override Expr getArgument(int i) { result = this.getPositionalArgument(i) }

  final override Expr getQualifier() { result = InvokeMemberExpr.super.getQualifier() }

  final override Expr getNamedArgument(string name) { none() }
}

final class Call = AbstractCall;
