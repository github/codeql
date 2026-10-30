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
    or
    certain = true and
    performsVariableAccess(_, v, TPostUpdate(), bb.getNode(i))
  }
}

module LocalSsaOutput = Make<Location, Cfg, LocalSsaInput>;

private import LocalSsaOutput

private module SsaInput implements SsaInputSig {
  private import codeql.unified.internal.ExprPositions

  class Expr = U::Expr;

  class Parameter = U::Parameter;

  class VariableWrite instanceof BuilderNode {
    private AstNode writeAccess;

    VariableWrite() { this.isLocalVariableWrite(writeAccess, _) }

    Expr asExpr() { hasIncomingValue(writeAccess, result) }

    Expr getValue() {
      exists(VariableDeclaration decl |
        writeAccess = decl.getPattern() and result = decl.getValue()
      )
      or
      exists(AssignExpr assignment |
        writeAccess = assignment.getTarget() and result = assignment.getValue()
      )
      or
      writeAccess = result.(CompoundAssignExpr).getTarget()
      // TODO: Add case for prefix unary crement operations
    }

    predicate isParameterInit(Parameter p) { p.getPattern() = writeAccess }

    string toString() { result = super.toString() }

    Location getLocation() { result = super.getLocation() }
  }

  predicate explicitWrite(VariableWrite w, BasicBlock bb, int i, LocalSsaInput::SourceVariable v) {
    exists(AstNode repr |
      w.(BuilderNode).isLocalVariableWrite(repr, v) and
      performsVariableAccess(repr, v, _, bb.getNode(i))
    )
  }
}

module SsaPublic {
  module Ssa = MakeSsa<SsaInput>;
}

module LocalSsaDataFlowInput implements DataFlowIntegrationInputSig {
  class Expr = LocalVariableRefNode;

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

Stage2Node getNodeFromLocalSsaNode(Ssa::Node n) {
  result = TLocalSsaNode(n)
  or
  result = n.(Ssa::ExprNode).getExpr() and
  not postUpdateReadNode(n)
  or
  result = n.(Ssa::ExprPostUpdateNode).getExpr().(BuilderNode).getPostUpdateNode()
  or
  exists(LocalVariable v, BasicBlock bb, int i, AstNode repr |
    n.(Ssa::WriteDefSourceNode).getDefinition().definesAt(v, bb, i) and
    performsVariableAccess(repr, v, TWrite(), bb.getNode(i)) and
    result.(BuilderNode).isLocalVariableWrite(repr, v)
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

predicate localSsaStep(Stage2Node node1, Stage2Node node2, boolean isUseStep) {
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

predicate localSsaMustFlowStep(Stage2Node node1, Stage2Node node2) {
  exists(Ssa::Node ssa1, Ssa::Node ssa2 |
    Ssa::localMustFlowStep(_, ssa1, ssa2) and
    node1 = getNodeFromLocalSsaNode(ssa1) and
    node2 = getNodeFromLocalSsaNode(ssa2)
  )
}
