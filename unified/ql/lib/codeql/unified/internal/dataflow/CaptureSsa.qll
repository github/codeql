/**
 * SSA for captured variables.
 */

private import unified
private import unified as U
private import AllDataFlow
private import codeql.dataflow.VariableCapture
private import codeql.unified.internal.ControlFlowGraph
private import codeql.unified.internal.ExprPositions

module CaptureSsaInput implements InputSig<Location, BasicBlock> {
  final private class FinalCallable = U::Callable;

  class Callable extends FinalCallable {
    Callable() { this.fromSource() }

    predicate isConstructor() { none() } // TODO
  }

  Callable basicBlockGetEnclosingCallable(BasicBlock bb) { result = bb.getEnclosingCallable() }

  class CapturedVariable extends LocalVariable {
    CapturedVariable() { this.isCaptured() }

    Callable getCallable() { result = super.getDeclaringCallable() }
  }

  class CapturedParameter extends CapturedVariable {
    // This class is not needed. Variables aren't the first point of contact with parameter values.
    CapturedParameter() { none() }
  }

  private class TExpr = TCallableNode or TLocalVariableRefNode;

  private predicate isTopLevelCallable(BuilderNode callable) {
    callable.isCallable(any(TopLevel t))
  }

  class Expr extends TExpr {
    Expr() { not isTopLevelCallable(this) }

    string toString() { result = this.(Node).toString() }

    Location getLocation() { result = this.(Node).getLocation() }

    predicate hasCfgNode(BasicBlock bb, int i) {
      this.(LocalVariableRefNode).hasCfgNode(bb, i)
      or
      exists(DataFlowCallable callable |
        this = TCallableNode(callable) and
        bb.getNode(i).injects(callable.asSourceCallable())
      )
    }
  }

  final private class FinalLocalVariableRefNode = LocalVariableRefNode;

  class VariableWrite extends FinalLocalVariableRefNode {
    VariableWrite() {
      this.getRefKind().isWrite() and super.getVariable() instanceof CapturedVariable
    }

    CapturedVariable getVariable() { result = super.getVariable() }
  }

  class VariableRead extends Expr instanceof LocalVariableRefNode {
    VariableRead() {
      super.getVariable() instanceof CapturedVariable and
      super.getRefKind().isRead()
    }

    CapturedVariable getVariable() { result = super.getVariable() }
  }

  class ClosureExpr extends Expr instanceof TCallableNode {
    private Callable callable;

    ClosureExpr() { this.(BuilderNode).isCallable(callable) }

    predicate hasBody(Callable body) { callable = body }

    predicate hasAliasedAccess(Expr f) { this = f } // TODO
  }
}

module CaptureSsaOutput = Flow<Location, Cfg, CaptureSsaInput>;
