/**
 * Provides classes for working with basic blocks.
 */
overlay[local]
module;

import go
private import ControlFlowGraphShared

/** A basic block in the control-flow graph. */
class BasicBlock = GoCfg::Cfg::BasicBlock;

/** An entry basic block. */
class EntryBasicBlock = GoCfg::Cfg::EntryBasicBlock;

/**
 * A basic block that is reachable from an entry basic block.
 *
 * Since the shared CFG library only creates nodes for reachable code,
 * all basic blocks are reachable by construction.
 */
class ReachableBasicBlock extends BasicBlock {
  ReachableBasicBlock() { any() }
}

/**
 * A reachable basic block with more than one predecessor.
 */
class ReachableJoinBlock extends ReachableBasicBlock {
  ReachableJoinBlock() { this.getFirstNode().(ControlFlow::Node).isJoin() }
}
