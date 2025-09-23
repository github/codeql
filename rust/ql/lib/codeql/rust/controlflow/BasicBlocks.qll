private import codeql.controlflow.BasicBlock as BB
private import codeql.Locations
private import codeql.rust.controlflow.ControlFlowGraph as ControlFlowGraph
private import internal.ControlFlowGraphImpl as CfgImpl
private import CfgImpl::BasicBlocks as BasicBlocksImpl

class BasicBlock = BasicBlocksImpl::BasicBlock;

final class EntryBasicBlock = BasicBlocksImpl::EntryBasicBlock;

final class ExitBasicBlock = BasicBlocksImpl::ExitBasicBlock;

final class AnnotatedExitBasicBlock = BasicBlocksImpl::AnnotatedExitBasicBlock;

final class ConditionBasicBlock = BasicBlocksImpl::ConditionBasicBlock;

final class JoinBasicBlock = BasicBlocksImpl::JoinBasicBlock;

final class JoinPredecessorBasicBlock = BasicBlocksImpl::JoinPredecessorBasicBlock;

module Cfg implements BB::CfgSig<Location> {
  class ControlFlowNode = ControlFlowGraph::CfgNode;

  class BasicBlock = BasicBlocksImpl::BasicBlock;

  class EntryBasicBlock = BasicBlocksImpl::EntryBasicBlock;

  predicate dominatingEdge = BasicBlocksImpl::dominatingEdge/2;
}
