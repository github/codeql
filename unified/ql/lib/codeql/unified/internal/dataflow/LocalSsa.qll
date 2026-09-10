private import unified
private import unified as U
private import AllDataFlow
private import codeql.ssa.Ssa
private import codeql.util.Void

module LocalSsaInput implements InputSig<Location, BasicBlock> {
  class SourceVariable extends LocalVariable {
    SourceVariable() { not this.isCaptured() }
  }

  predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain) {
    certain = true and
    performsVariableAccess(_, v, TWrite(), bb.getNode(i))
  }

  predicate variableRead(BasicBlock bb, int i, SourceVariable v, boolean certain) {
    certain = true and
    performsVariableAccess(_, v, TRead(), bb.getNode(i))
  }
}

module LocalSsaOutput = Make<Location, Cfg, LocalSsaInput>;

private import LocalSsaOutput

module LocalSsaDataFlowInput implements DataFlowIntegrationInputSig {
  class Expr extends TLocalVariableRefNode {
    predicate hasCfgNode(BasicBlock bb, int i) {
      exists(U::Expr expr, LocalVariable var, VariableRefKind kind |
        this = TLocalVariableRefNode(expr, var, kind) and
        kind.isRead() and
        performsVariableAccess(expr, var, kind, bb.getNode(i))
      )
    }

    string toString() { result = this.(Node).toString() }
  }

  class GuardValue = Void;

  class Guard extends Void {
    string toString() { none() }

    predicate hasValueBranchEdge(BasicBlock bb1, BasicBlock bb2, GuardValue val) { none() }

    predicate valueControlsBranchEdge(BasicBlock bb1, BasicBlock bb2, GuardValue val) { none() }
  }

  predicate guardDirectlyControlsBlock(Guard guard, BasicBlock bb, GuardValue val) { none() }
}

module LocalSsaDataFlowOutput = DataFlowIntegration<LocalSsaDataFlowInput>;

private module Ssa = LocalSsaDataFlowOutput;

Node getNodeFromLocalSsaNode(Ssa::Node n) {
  result = TLocalSsaNode(n)
  or
  result = n.(Ssa::ExprNode).getExpr()
  or
  result = getPostUpdateNode(n.(Ssa::ExprPostUpdateNode).getExpr())
  or
  exists(LocalVariable v, BasicBlock bb, int i, Expr expr |
    n.(Ssa::WriteDefSourceNode).getDefinition().definesAt(v, bb, i) and
    performsVariableAccess(expr, v, TWrite(), bb.getNode(i)) and
    result.isLocalVariableWrite(expr, v)
  )
}

predicate localSsaStep(Node node1, Node node2, boolean isUseStep) {
  exists(Ssa::Node ssa1, Ssa::Node ssa2 |
    Ssa::localFlowStep(_, ssa1, ssa2, isUseStep) and
    node1 = getNodeFromLocalSsaNode(ssa1) and
    node2 = getNodeFromLocalSsaNode(ssa2)
  )
}

predicate localSsaMustFlowStep(Node node1, Node node2) {
  exists(Ssa::Node ssa1, Ssa::Node ssa2 |
    Ssa::localMustFlowStep(_, ssa1, ssa2) and
    node1 = getNodeFromLocalSsaNode(ssa1) and
    node2 = getNodeFromLocalSsaNode(ssa2)
  )
}
