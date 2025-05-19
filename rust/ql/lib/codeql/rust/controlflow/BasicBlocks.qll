private import internal.ControlFlowGraphImpl as CfgImpl
private import CfgImpl::BasicBlocks as BasicBlocksImpl

final class BasicBlock = BasicBlocksImpl::BasicBlock;

final class EntryBasicBlock = BasicBlocksImpl::EntryBasicBlock;

final class ExitBasicBlock = BasicBlocksImpl::ExitBasicBlock;

final class AnnotatedExitBasicBlock = BasicBlocksImpl::AnnotatedExitBasicBlock;

final class ConditionBasicBlock = BasicBlocksImpl::ConditionBasicBlock;

final class JoinBasicBlock = BasicBlocksImpl::JoinBasicBlock;

final class JoinPredecessorBasicBlock = BasicBlocksImpl::JoinPredecessorBasicBlock;
