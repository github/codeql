import powershell

abstract private class AbstractCall extends Ast {
  abstract Expr getCommand();

  abstract Expr getArgument(int i);

  Expr getNamedArgument(string name) { none() }

  Expr getAnArgument() { result = this.getArgument(_) or result = this.getNamedArgument(_) }

  Expr getQualifier() { none() }
}

private class CmdCall extends AbstractCall instanceof Cmd {
  final override Expr getCommand() { result = Cmd.super.getCommand() }

  final override Expr getArgument(int i) { result = Cmd.super.getArgument(i) }

  final override Expr getNamedArgument(string name) { result = Cmd.super.getNamedArgument(name) }
}

private class InvokeMemberCall extends AbstractCall instanceof InvokeMemberExpr {
  final override Expr getCommand() { result = super.getMember() }

  final override Expr getArgument(int i) { result = InvokeMemberExpr.super.getArgument(i) }

  final override Expr getQualifier() { result = InvokeMemberExpr.super.getQualifier() }
}

final class Call = AbstractCall;
