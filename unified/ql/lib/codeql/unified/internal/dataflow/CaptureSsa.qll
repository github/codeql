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

  /**
   * Holds if `node` is a possible alias for `callable`.
   */
  private predicate callableHasLocalAlias(Callable callable, Stage2Node node) {
    node.(BuilderNode).isCallable(callable)
    or
    exists(Stage2Node prev | callableHasLocalAlias(callable, prev) |
      step(prev, any(Step s | s.value()), node)
      or
      localSsaStep(prev, node, _)
    )
    or
    exists(CapturedVariable var |
      callableHasLocalAliasVar(callable, var) and
      node.(BuilderNode).isLocalVariableRead(_, var)
    )
  }

  pragma[nomagic]
  private predicate callableHasLocalAliasVar(Callable callable, CapturedVariable var) {
    exists(BuilderNode ref |
      callableHasLocalAlias(callable, ref) and
      ref.isLocalVariableWrite(_, var)
    )
  }

  class ClosureExpr extends Expr instanceof TCallableNode {
    private Callable callable;

    ClosureExpr() { this.(BuilderNode).isCallable(callable) }

    predicate hasBody(Callable body) { callable = body }

    predicate hasAliasedAccess(Expr f) { callableHasLocalAlias(callable, f) }
  }
}

module CaptureSsaOutput = Flow<Location, Cfg, CaptureSsaInput>;

Node getNodeFromCaptureSsaNode(CaptureSsaOutput::ClosureNode n) {
  result = TCaptureSsaNode(n)
  or
  result = n.(CaptureSsaOutput::ExprNode).getExpr()
  or
  result = n.(CaptureSsaOutput::ExprPostUpdateNode).getExpr().(BuilderNode).getPostUpdateNode()
  or
  result = n.(CaptureSsaOutput::VariableWriteSourceNode).getVariableWrite()
  or
  // NOTE: This only supports lambdas at the moment. Local classes in Swift cannot capture variables.
  result = n.(CaptureSsaOutput::MallocNode).getClosureExpr()
  or
  exists(CaptureSsaOutput::ThisParameterNode thisParam, Callable callable |
    n = thisParam and
    callable = thisParam.getCallable() and
    result
        .(BuilderNode)
        .isImplicitParameter(getDataFlowCallable(callable), any(ParameterPosition p | p.isCallee()))
  )
}
