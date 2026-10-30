/**
 * SSA for non-captured variables.
 */

private import unified
private import unified as U
private import AllDataFlow
private import codeql.ssa.Ssa
private import codeql.util.Void

module LocalSsaInput implements InputSig<Location, BasicBlock> {
  class SourceVariable extends LocalVariable {
    SourceVariable() { not this.isCaptured() and not this instanceof ComputedLocalVariable }
  }

  predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain) {
    certain = true and
    (
      performsVariableAccess(_, v, TWrite(), bb.getNode(i))
      or
      // Add implicit initialization of all variables at index -1 before the entry block
      bb.(EntryBasicBlock).getEnclosingCallable() = v.getDeclaringCallable() and
      i = -1
    )
  }

  predicate variableRead(BasicBlock bb, int i, SourceVariable v, boolean certain) {
    certain = true and
    performsVariableAccess(_, v, TRead(), bb.getNode(i))
  }

  predicate variableReadWithPostUpdate(
    BasicBlock bb1, int i1, SourceVariable v, BasicBlock bb2, int i2
  ) {
    exists(U::AstNode repr |
      performsVariableAccess(repr, v, TRead(), bb1.getNode(i1)) and
      performsVariableAccess(repr, v, TPostUpdate(), bb2.getNode(i2))
    )
  }
}

module LocalSsaOutput = Make<Location, Cfg, LocalSsaInput>;

private import LocalSsaOutput

module LocalSsaDataFlowInput implements DataFlowIntegrationInputSig {
  class Expr extends ControlFlowNode {
    predicate hasCfgNode(BasicBlock bb, int i) { this = bb.getNode(i) }
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

Stage2Node getNodeFromLocalSsaNode(Ssa::Node n) {
  result = TLocalSsaNode(n)
  or
  exists(ControlFlowNode cfgnode, LocalVariable v, AstNode repr |
    n.(Ssa::ExprNode).isExprAndVariable(cfgnode, v) and
    performsVariableAccess(repr, v, TRead(), cfgnode) and
    result.(BuilderNode).isLocalVariableRead(repr, v)
  )
  or
  exists(ControlFlowNode cfgnode, LocalVariable v, AstNode repr |
    n.(Ssa::ExprPostUpdateNode).isExprAndVariable(cfgnode, v) and
    performsVariableAccess(repr, v, TPostUpdate(), cfgnode) and
    result.(BuilderNode).isLocalVariablePostUpdate(repr, v)
  )
  or
  exists(LocalVariable v, BasicBlock bb, int i, AstNode repr |
    n.(Ssa::WriteDefSourceNode).getDefinition().definesAt(v, bb, i) and
    performsVariableAccess(repr, v, TWrite(), bb.getNode(i)) and
    result.(BuilderNode).isLocalVariableWrite(repr, v)
  )
}

predicate localSsaStep(Stage2Node node1, Stage2Node node2, boolean isUseStep) {
  exists(Ssa::Node ssa1, Ssa::Node ssa2 |
    Ssa::localFlowStep(_, ssa1, ssa2, isUseStep) and
    node1 = getNodeFromLocalSsaNode(ssa1) and
    node2 = getNodeFromLocalSsaNode(ssa2)
  )
}

predicate localSsaMustFlowStep(Stage2Node node1, Stage2Node node2) {
  exists(Ssa::Node ssa1, Ssa::Node ssa2 |
    Ssa::localMustFlowStep(_, ssa1, ssa2) and
    node1 = getNodeFromLocalSsaNode(ssa1) and
    node2 = getNodeFromLocalSsaNode(ssa2)
  )
}
