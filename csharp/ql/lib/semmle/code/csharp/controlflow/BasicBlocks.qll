/**
 * Provides classes representing basic blocks.
 */

import csharp
private import ControlFlow::SuccessorTypes
private import semmle.code.csharp.controlflow.internal.ControlFlowGraphImpl as CfgImpl
private import CfgImpl::BasicBlocks as BasicBlocksImpl

/**
 * A basic block, that is, a maximal straight-line sequence of control flow nodes
 * without branches or joins.
 */
final class BasicBlock extends BasicBlocksImpl::BasicBlock {
  /** Gets an immediate successor of this basic block of a given type, if any. */
  BasicBlock getASuccessorByType(ControlFlow::SuccessorType t) { result = this.getASuccessor(t) }

  /** Gets an immediate predecessor of this basic block of a given type, if any. */
  BasicBlock getAPredecessorByType(ControlFlow::SuccessorType t) {
    result = this.getAPredecessor(t)
  }

  /**
   * Gets an immediate `true` successor, if any.
   *
   * An immediate `true` successor is a successor that is reached when
   * the condition that ends this basic block evaluates to `true`.
   *
   * Example:
   *
   * ```csharp
   * if (x < 0)
   *   x = -x;
   * ```
   *
   * The basic block on line 2 is an immediate `true` successor of the
   * basic block on line 1.
   */
  BasicBlock getATrueSuccessor() { result.getFirstNode() = this.getLastNode().getATrueSuccessor() }

  /**
   * Gets an immediate `false` successor, if any.
   *
   * An immediate `false` successor is a successor that is reached when
   * the condition that ends this basic block evaluates to `false`.
   *
   * Example:
   *
   * ```csharp
   * if (!(x >= 0))
   *   x = -x;
   * ```
   *
   * The basic block on line 2 is an immediate `false` successor of the
   * basic block on line 1.
   */
  BasicBlock getAFalseSuccessor() {
    result.getFirstNode() = this.getLastNode().getAFalseSuccessor()
  }

  /** Gets the control flow node at a specific (zero-indexed) position in this basic block. */
  ControlFlow::Node getNode(int pos) { result = super.getNode(pos) }

  /** Gets a control flow node in this basic block. */
  ControlFlow::Node getANode() { result = super.getANode() }

  /** Gets the first control flow node in this basic block. */
  ControlFlow::Node getFirstNode() { result = super.getFirstNode() }

  /** Gets the last control flow node in this basic block. */
  ControlFlow::Node getLastNode() { result = super.getLastNode() }

  /** Gets the callable that this basic block belongs to. */
  final Callable getCallable() { result = this.getFirstNode().getEnclosingCallable() }

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
   * ```csharp
   * int M(string s) {
   *   if (s == null)
   *     throw new ArgumentNullException(nameof(s));
   *   return s.Length;
   * }
   * ```
   *
   * The basic block starting on line 2 strictly dominates the
   * basic block on line 4 (all paths from the entry point of `M`
   * to `return s.Length;` must go through the null check).
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
   * ```csharp
   * int M(string s) {
   *   if (s == null)
   *     throw new ArgumentNullException(nameof(s));
   *   return s.Length;
   * }
   * ```
   *
   * The basic block starting on line 2 strictly dominates the
   * basic block on line 4 (all paths from the entry point of `M`
   * to `return s.Length;` must go through the null check).
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
   * ```csharp
   * int M(string s) {
   *   if (s == null)
   *     throw new ArgumentNullException(nameof(s));
   *   return s.Length;
   * }
   * ```
   *
   * The basic block starting on line 2 dominates the basic
   * block on line 4 (all paths from the entry point of `M` to
   * `return s.Length;` must go through the null check).
   *
   * This predicate is *reflexive*, so for example `if (s == null)` dominates
   * itself.
   */
  predicate dominates(BasicBlock bb) {
    bb = this or
    this.strictlyDominates(bb)
  }

  /**
   * Holds if `df` is in the dominance frontier of this basic block.
   * That is, this basic block dominates a predecessor of `df`, but
   * does not dominate `df` itself.
   *
   * Example:
   *
   * ```csharp
   * if (x < 0) {
   *   x = -x;
   *   if (x > 10)
   *     x--;
   * }
   * Console.Write(x);
   * ```
   *
   * The basic block on line 6 is in the dominance frontier
   * of the basic block starting on line 2 because that block
   * dominates the basic block on line 4, which is a predecessor of
   * `Console.Write(x);`. Also, the basic block starting on line 2
   * does not dominate the basic block on line 6.
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
   * ```csharp
   * int M(string s) {
   *   if (s == null)
   *     throw new ArgumentNullException(nameof(s));
   *   return s.Length;
   * }
   * ```
   *
   * The basic block starting on line 2 is an immediate dominator of
   * the basic block online 4 (all paths from the entry point of `M`
   * to `return s.Length;` must go through the null check.
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
   * ```csharp
   * int M(string s) {
   *   try {
   *     return s.Length;
   *   }
   *   finally {
   *     Console.WriteLine("M");
   *   }
   * }
   * ```
   *
   * The basic block on line 6 strictly post-dominates the basic block on
   * line 3 (all paths to the exit point of `M` from `return s.Length;`
   * must go through the `WriteLine` call).
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
   * ```csharp
   * int M(string s) {
   *   try {
   *     return s.Length;
   *   }
   *   finally {
   *     Console.WriteLine("M");
   *   }
   * }
   * ```
   *
   * The basic block on line 6 post-dominates the basic block on line 3
   * (all paths to the exit point of `M` from `return s.Length;` must go
   * through the `WriteLine` call).
   *
   * This predicate is *reflexive*, so for example `Console.WriteLine("M");`
   * post-dominates itself.
   */
  predicate postDominates(BasicBlock bb) { super.postDominates(bb) }

  /**
   * Holds if this basic block is in a loop in the control flow graph. This
   * includes loops created by `goto` statements. This predicate may not hold
   * even if this basic block is syntactically inside a `while` loop if the
   * necessary back edges are unreachable.
   */
  predicate inLoop() { this.getASuccessor+() = this }
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
  predicate immediatelyControls(BasicBlock succ, ConditionalSuccessor s) {
    super.immediatelyControls(succ, s)
  }

  predicate controls(BasicBlock controlled, ConditionalSuccessor s) {
    super.controls(controlled, s)
  }
}
