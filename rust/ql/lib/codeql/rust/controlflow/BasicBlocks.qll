private import codeql.controlflow.BasicBlock as BB
private import codeql.Locations
private import codeql.rust.elements.internal.generated.Raw
private import codeql.rust.elements.internal.generated.Synth
private import codeql.rust.controlflow.ControlFlowGraph as ControlFlowGraph
private import internal.ControlFlowGraphImpl as CfgImpl

class BasicBlock = CfgImpl::Cfg::BasicBlock;

final class EntryBasicBlock extends BasicBlock {
  EntryBasicBlock() { this.getFirstNode() instanceof CfgImpl::ControlFlow::EntryNode }
}

final class ExitBasicBlock extends BasicBlock {
  ExitBasicBlock() { this.getLastNode() instanceof CfgImpl::ControlFlow::ExitNode }
}

final class AnnotatedExitBasicBlock extends BasicBlock {
  AnnotatedExitBasicBlock() {
    this.getANode() instanceof CfgImpl::ControlFlow::AnnotatedExitNode
  }

  /** Holds if this block represents normal exit. */
  predicate isNormal() {
    this.getANode() instanceof CfgImpl::ControlFlow::NormalExitNode
  }
}

final class ConditionBasicBlock extends BasicBlock {
  ConditionBasicBlock() { this.getLastNode().(ControlFlowGraph::CfgNode).isCondition() }
}

final class JoinBasicBlock extends BasicBlock {
  JoinBasicBlock() { this.getFirstNode().(ControlFlowGraph::CfgNode).isJoin() }

  /** Gets the `i`th predecessor of this join block in a stable arbitrary order. */
  JoinPredecessorBasicBlock getJoinBlockPredecessor(int i) {
    result =
      rank[i + 1](JoinPredecessorBasicBlock pred, int id, string tag |
        pred = this.getAPredecessor() and
        id = getNodeId(pred.getFirstNode()) and
        tag = pred.getFirstNode().getIdTag()
      |
        pred order by id, tag
      )
  }
}

final class JoinPredecessorBasicBlock extends BasicBlock {
  JoinPredecessorBasicBlock() { this.getASuccessor() instanceof JoinBasicBlock }
}

private predicate id(Raw::AstNode x, Raw::AstNode y) { x = y }

private predicate idOfDbAstNode(Raw::AstNode x, int y) = equivalenceRelation(id/2)(x, y)

private int getNodeId(CfgImpl::ControlFlowNode node) {
  idOfDbAstNode(Synth::convertAstNodeToRaw(node.getAstNode()), result)
}

module Cfg implements BB::CfgSig<Location> {
  class ControlFlowNode = CfgImpl::Cfg::ControlFlowNode;

  class BasicBlock = CfgImpl::Cfg::BasicBlock;

  class EntryBasicBlock = CfgImpl::Cfg::EntryBasicBlock;

  predicate dominatingEdge = CfgImpl::Cfg::dominatingEdge/2;
}
