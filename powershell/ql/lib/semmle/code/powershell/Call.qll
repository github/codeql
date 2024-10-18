import powershell
private import semmle.code.powershell.dataflow.internal.DataFlowImplCommon
private import semmle.code.powershell.dataflow.internal.DataFlowDispatch
private import semmle.code.powershell.controlflow.CfgNodes

abstract private class AbstractCall extends Ast {
  abstract Expr getCommand();

  abstract string getName();

  /** Gets the i'th argument to this call. */
  abstract Expr getArgument(int i);

  /** Gets the i'th positional argument to this call. */
  abstract Expr getPositionalArgument(int i);

  /** Holds if an argument with name `name` is provided to this call. */
  final predicate hasNamedArgument(string name) { exists(this.getNamedArgument(name)) }

  /** Gets the argument to this call with the name `name`. */
  abstract Expr getNamedArgument(string name);

  /** Gets any argument to this call. */
  final Expr getAnArgument() { result = this.getArgument(_) }

  /** Gets the qualifier of this call, if any. */
  Expr getQualifier() { none() }

  /** Gets a possible runtime target of this call. */
  abstract Function getATarget();
}

/** A call to a command. For example, `Write-Host "Hello, world!"`. */
class CmdCall extends AbstractCall instanceof Cmd {
  final override Expr getCommand() { result = Cmd.super.getCommand() }

  final override Expr getPositionalArgument(int i) { result = Cmd.super.getPositionalArgument(i) }

  final override string getName() { result = Cmd.super.getCommandName() }

  final override Expr getArgument(int i) { result = Cmd.super.getArgument(i) }

  final override Expr getNamedArgument(string name) { result = Cmd.super.getNamedArgument(name) }

  final override Function getATarget() {
    exists(DataFlowCall call | call.asCall().(StmtNodes::CmdCfgNode).getStmt() = this |
      result.getBody() = viableCallableLambda(call, _).asCfgScope()
      or
      result.getBody() = getTarget(call)
    )
  }
}

/** A call to a method on an object. For example, `$obj.ToString()`. */
class MethodCall extends AbstractCall instanceof InvokeMemberExpr {
  final override Expr getCommand() { result = super.getMember() }

  final override Expr getPositionalArgument(int i) {
    result = InvokeMemberExpr.super.getArgument(i)
  }

  final override Expr getArgument(int i) { result = this.getPositionalArgument(i) }

  final override Expr getQualifier() { result = InvokeMemberExpr.super.getQualifier() }

  final override Expr getNamedArgument(string name) { none() }

  final override Function getATarget() {
    exists(DataFlowCall call | call.asCall().(ExprNodes::InvokeMemberCfgNode).getExpr() = this |
      result.getBody() = viableCallableLambda(call, _).asCfgScope()
      or
      result.getBody() = getTarget(call)
    )
  }

  final override string getName() { result = InvokeMemberExpr.super.getName() }
}

final class Call = AbstractCall;
