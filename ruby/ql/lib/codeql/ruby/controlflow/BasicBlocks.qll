/** Provides classes representing basic blocks. */

private import codeql.ruby.AST
private import codeql.ruby.ast.internal.AST
private import codeql.ruby.ast.internal.TreeSitter
private import codeql.ruby.controlflow.ControlFlowGraph
private import internal.ControlFlowGraphImpl as CfgImpl
private import CfgNodes
private import SuccessorTypes
private import CfgImpl::BasicBlocks as BasicBlocksImpl

/**
 * A basic block, that is, a maximal straight-line sequence of control flow nodes
 * without branches or joins.
 */
final class BasicBlock extends BasicBlocksImpl::BasicBlock {
  /** Gets an immediate successor of this basic block, if any. */
  BasicBlock getASuccessor() { result = super.getASuccessor() }

  /** Gets an immediate successor of this basic block of a given type, if any. */
  BasicBlock getASuccessor(SuccessorType t) { result = super.getASuccessor(t) }

  /** Gets an immediate predecessor of this basic block, if any. */
  BasicBlock getAPredecessor() { result = super.getAPredecessor() }

  /** Gets an immediate predecessor of this basic block of a given type, if any. */
  BasicBlock getAPredecessor(SuccessorType t) { result = super.getAPredecessor(t) }

  // The overrides below are to use `CfgNode` instead of `CfgImpl::Node`
  CfgNode getNode(int pos) { result = super.getNode(pos) }

  CfgNode getANode() { result = super.getANode() }

  /** Gets the first control flow node in this basic block. */
  CfgNode getFirstNode() { result = super.getFirstNode() }

  /** Gets the last control flow node in this basic block. */
  CfgNode getLastNode() { result = super.getLastNode() }

  /**
   * Holds if this basic block immediately dominates basic block `bb`.
   *
   * That is, this basic block is the unique basic block satisfying:
   * 1. This basic block strictly dominates `bb`
   * 2. There exists no other basic block that is strictly dominated by this
   *    basic block and which strictly dominates `bb`.
   *
   * All basic blocks, except entry basic blocks, have a unique immediate
   * dominator.
   *
   * Example:
   *
   * ```rb
   * def m b
   *   if b
   *     return 0
   *   end
   *   return 1
   * end
   * ```
   *
   * The basic block starting on line 2 immediately dominates the
   * basic block on line 5 (all paths from the entry point of `m`
   * to `return 1` must go through the `if` block).
   */
  predicate immediatelyDominates(BasicBlock bb) { super.immediatelyDominates(bb) }

  /**
   * Holds if this basic block strictly dominates basic block `bb`.
   *
   * That is, all paths reaching basic block `bb` from some entry point
   * basic block must go through this basic block (which must be different
   * from `bb`).
   *
   * Example:
   *
   * ```rb
   * def m b
   *   if b
   *     return 0
   *   end
   *   return 1
   * end
   * ```
   *
   * The basic block starting on line 2 strictly dominates the
   * basic block on line 5 (all paths from the entry point of `m`
   * to `return 1` must go through the `if` block).
   */
  predicate strictlyDominates(BasicBlock bb) { super.strictlyDominates(bb) }

  /**
   * Holds if this basic block dominates basic block `bb`.
   *
   * That is, all paths reaching basic block `bb` from some entry point
   * basic block must go through this basic block.
   *
   * Example:
   *
   * ```rb
   * def m b
   *   if b
   *     return 0
   *   end
   *   return 1
   * end
   * ```
   *
   * The basic block starting on line 2 dominates the basic
   * basic block on line 5 (all paths from the entry point of `m`
   * to `return 1` must go through the `if` block).
   */
  predicate dominates(BasicBlock bb) { super.dominates(bb) }

  /**
   * Holds if `df` is in the dominance frontier of this basic block.
   * That is, this basic block dominates a predecessor of `df`, but
   * does not dominate `df` itself.
   *
   * Example:
   *
   * ```rb
   * def m x
   *   if x < 0
   *     x = -x
   *     if x > 10
   *       x = x - 1
   *     end
   *   end
   *   puts x
   * end
   * ```
   *
   * The basic block on line 8 is in the dominance frontier
   * of the basic block starting on line 3 because that block
   * dominates the basic block on line 4, which is a predecessor of
   * `puts x`. Also, the basic block starting on line 3 does not
   * dominate the basic block on line 8.
   */
  predicate inDominanceFrontier(BasicBlock df) { super.inDominanceFrontier(df) }

  /**
   * Gets the basic block that immediately dominates this basic block, if any.
   *
   * That is, the result is the unique basic block satisfying:
   * 1. The result strictly dominates this basic block.
   * 2. There exists no other basic block that is strictly dominated by the
   *    result and which strictly dominates this basic block.
   *
   * All basic blocks, except entry basic blocks, have a unique immediate
   * dominator.
   *
   * Example:
   *
   * ```rb
   * def m b
   *   if b
   *     return 0
   *   end
   *   return 1
   * end
   * ```
   *
   * The basic block starting on line 2 is an immediate dominator of
   * the basic block on line 5 (all paths from the entry point of `m`
   * to `return 1` must go through the `if` block, and the `if` block
   * is an immediate predecessor of `return 1`).
   */
  BasicBlock getImmediateDominator() { result = super.getImmediateDominator() }

  /**
   * Holds if this basic block strictly post-dominates basic block `bb`.
   *
   * That is, all paths reaching a normal exit point basic block from basic
   * block `bb` must go through this basic block (which must be different
   * from `bb`).
   *
   * Example:
   *
   * ```rb
   * def m b
   *   if b
   *     puts "b"
   *   end
   *   puts "m"
   * end
   * ```
   *
   * The basic block on line 5 strictly post-dominates the basic block on
   * line 3 (all paths to the exit point of `m` from `puts "b"` must go
   * through `puts "m"`).
   */
  predicate strictlyPostDominates(BasicBlock bb) { super.strictlyPostDominates(bb) }

  /**
   * Holds if this basic block post-dominates basic block `bb`.
   *
   * That is, all paths reaching a normal exit point basic block from basic
   * block `bb` must go through this basic block.
   *
   * Example:
   *
   * ```rb
   * def m b
   *   if b
   *     puts "b"
   *   end
   *   puts "m"
   * end
   * ```
   *
   * The basic block on line 5 post-dominates the basic block on line 3
   * (all paths to the exit point of `m` from `puts "b"` must go through
   * `puts "m"`).
   */
  predicate postDominates(BasicBlock bb) { super.postDominates(bb) }
}

/**
 * An entry basic block, that is, a basic block whose first node is
 * an entry node.
 */
final class EntryBasicBlock extends BasicBlock, BasicBlocksImpl::EntryBasicBlock { }

/**
 * An annotated exit basic block, that is, a basic block that contains an
 * annotated exit node.
 */
final class AnnotatedExitBasicBlock extends BasicBlock, BasicBlocksImpl::AnnotatedExitBasicBlock { }

/**
 * An exit basic block, that is, a basic block whose last node is
 * an exit node.
 */
final class ExitBasicBlock extends BasicBlock, BasicBlocksImpl::ExitBasicBlock { }

/** A basic block with more than one predecessor. */
final class JoinBlock extends BasicBlock, BasicBlocksImpl::JoinBasicBlock {
  JoinBlockPredecessor getJoinBlockPredecessor(int i) { result = super.getJoinBlockPredecessor(i) }
}

/** A basic block that is an immediate predecessor of a join block. */
final class JoinBlockPredecessor extends BasicBlock, BasicBlocksImpl::JoinPredecessorBasicBlock { }

/**
 * A basic block that terminates in a condition, splitting the subsequent
 * control flow.
 */
final class ConditionBlock extends BasicBlock, BasicBlocksImpl::ConditionBasicBlock {
  /**
   * Holds if basic block `succ` is immediately controlled by this basic
   * block with conditional value `s`. That is, `succ` is an immediate
   * successor of this block, and `succ` can only be reached from
   * the callable entry point by going via the `s` edge out of this basic block.
   */
  predicate immediatelyControls(BasicBlock succ, ConditionalSuccessor s) {
    super.immediatelyControls(succ, s)
  }

  /**
   * Holds if basic block `controlled` is controlled by this basic block with
   * conditional value `s`. That is, `controlled` can only be reached from the
   * callable entry point by going via the `s` edge out of this basic block.
   */
  predicate controls(BasicBlock controlled, ConditionalSuccessor s) {
    super.controls(controlled, s)
  }
}
