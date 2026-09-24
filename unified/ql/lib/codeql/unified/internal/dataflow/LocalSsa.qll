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
    SourceVariable() { not this.isCaptured() }
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
    or
    certain = true and
    performsVariableAccess(_, v, TPostUpdate(), bb.getNode(i))
  }
}

module LocalSsaOutput = Make<Location, Cfg, LocalSsaInput>;

private import LocalSsaOutput

module LocalSsaDataFlowInput implements DataFlowIntegrationInputSig {
  class Expr extends TLocalVariableRefNode {
    U::AstNode repr;
    LocalVariable var;
    VariableRefKind kind;

    Expr() { this = TLocalVariableRefNode(repr, var, kind) }

    predicate hasCfgNode(BasicBlock bb, int i) {
      this = TLocalVariableRefNode(repr, var, kind) and
      // Note: the synthetic read we insert for post-updates must also have an Expr
      (kind.isRead() or kind.isPostUpdate()) and
      performsVariableAccess(repr, var, kind, bb.getNode(i))
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

  predicate postUpdateCfgNode(Expr read, BasicBlock bb, int i) {
    exists(LocalVariable var, U::AstNode repr |
      read = TLocalVariableRefNode(repr, var, TRead()) and
      performsVariableAccess(repr, var, TPostUpdate(), bb.getNode(i))
    )
  }
}

module LocalSsaDataFlowOutput = DataFlowIntegration<LocalSsaDataFlowInput>;

private module Ssa = LocalSsaDataFlowOutput;

/**
 * Holds if `node` represents the synthetic read we use to represent a post-update node.
 *
 * We want to skip use-use flow through such a node, as we don't want use-use ordinary flow
 * targeting a post-update node.
 */
private predicate postUpdateReadNode(Ssa::Node node) {
  node.(Ssa::ExprNode).getExpr() = TLocalVariableRefNode(_, _, TPostUpdate())
}

Node getNodeFromLocalSsaNode(Ssa::Node n) {
  result = TLocalSsaNode(n)
  or
  result = n.(Ssa::ExprNode).getExpr() and
  not postUpdateReadNode(n)
  or
  result = getPostUpdateNode(n.(Ssa::ExprPostUpdateNode).getExpr())
  or
  exists(LocalVariable v, BasicBlock bb, int i, AstNode repr |
    n.(Ssa::WriteDefSourceNode).getDefinition().definesAt(v, bb, i) and
    performsVariableAccess(repr, v, TWrite(), bb.getNode(i)) and
    result.isLocalVariableWrite(repr, v)
  )
}

/**
 * Holds if there is use-use flow from `node1`, through one or more post-update reads, into `node2`.
 */
predicate skipPostUpdateRead(Ssa::Node node1, Ssa::Node node2) {
  Ssa::localFlowStep(_, node1, node2, true) and
  postUpdateReadNode(node2)
  or
  exists(Ssa::Node mid |
    skipPostUpdateRead(node1, mid) and
    postUpdateReadNode(mid) and
    Ssa::localFlowStep(_, mid, node2, _)
  )
}

predicate localSsaStep(Node node1, Node node2, boolean isUseStep) {
  exists(Ssa::Node ssa1, Ssa::Node ssa2 |
    (
      Ssa::localFlowStep(_, ssa1, ssa2, isUseStep)
      or
      skipPostUpdateRead(ssa1, ssa2) and
      isUseStep = true
    ) and
    not postUpdateReadNode(ssa2) and
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
