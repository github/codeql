/**
 * Provides classes representing basic blocks.
 */

private import CIL

/**
 * A basic block, that is, a maximal straight-line sequence of control flow nodes
 * without branches or joins.
 */
class BasicBlock extends Cached::TBasicBlockStart {
  /** Gets an immediate successor of this basic block, if any. */
  BasicBlock getASuccessor() { result.getFirstNode() = getLastNode().getASuccessor() }

  /** Gets an immediate predecessor of this basic block, if any. */
  BasicBlock getAPredecessor() { result.getASuccessor() = this }

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
  BasicBlock getATrueSuccessor() { result.getFirstNode() = getLastNode().getTrueSuccessor() }

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
  BasicBlock getAFalseSuccessor() { result.getFirstNode() = getLastNode().getFalseSuccessor() }

  /** Gets the control flow node at a specific (zero-indexed) position in this basic block. */
  ControlFlowNode getNode(int pos) { Cached::bbIndex(getFirstNode(), result, pos) }

  /** Gets a control flow node in this basic block. */
  ControlFlowNode getANode() { result = getNode(_) }

  /** Gets the first control flow node in this basic block. */
  ControlFlowNode getFirstNode() { this = Cached::TBasicBlockStart(result) }

  /** Gets the last control flow node in this basic block. */
  ControlFlowNode getLastNode() { result = getNode(length() - 1) }

  /** Gets the length of this basic block. */
  int length() { result = strictcount(getANode()) }

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
  predicate strictlyDominates(BasicBlock bb) { bbIDominates+(this, bb) }

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
    strictlyDominates(bb)
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
  predicate inDominanceFrontier(BasicBlock df) {
    dominatesPredecessor(df) and
    not strictlyDominates(df)
  }

  /**
   * Holds if this basic block dominates a predecessor of `df`.
   */
  private predicate dominatesPredecessor(BasicBlock df) { dominates(df.getAPredecessor()) }

  /**
   * Gets the basic block that immediately dominates this basic block, if any.
   *
   * That is, all paths reaching this basic block from some entry point
   * basic block must go through the result, which is an immediate basic block
   * predecessor of this basic block.
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
   * to `return s.Length;` must go through the null check, and the null check
   * is an immediate predecessor of `return s.Length;`).
   */
  BasicBlock getImmediateDominator() { bbIDominates(result, this) }

  /**
   * Holds if this basic block strictly post-dominates basic block `bb`.
   *
   * That is, all paths reaching an exit point basic block from basic
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
  predicate strictlyPostDominates(BasicBlock bb) { bbIPostDominates+(this, bb) }

  /**
   * Holds if this basic block post-dominates basic block `bb`.
   *
   * That is, all paths reaching an exit point basic block from basic
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
  predicate postDominates(BasicBlock bb) {
    strictlyPostDominates(bb) or
    this = bb
  }

  /**
   * Holds if this basic block is in a loop in the control flow graph. This
   * includes loops created by `goto` statements. This predicate may not hold
   * even if this basic block is syntactically inside a `while` loop if the
   * necessary back edges are unreachable.
   */
  predicate inLoop() { this.getASuccessor+() = this }

  /** Gets a textual representation of this basic block. */
  string toString() { result = getFirstNode().toString() }
}

/**
 * Internal implementation details.
 */
cached
private module Cached {
  /** Internal representation of basic blocks. */
  cached
  newtype TBasicBlock = TBasicBlockStart(ControlFlowNode cfn) { startsBB(cfn) }

  /** Holds if `cfn` starts a new basic block. */
  private predicate startsBB(ControlFlowNode cfn) {
    not exists(cfn.getAPredecessor()) and exists(cfn.getASuccessor())
    or
    cfn.isJoin()
    or
    cfn.getAPredecessor().isBranch()
  }

  /**
   * Holds if `succ` is a control flow successor of `pred` within
   * the same basic block.
   */
  private predicate intraBBSucc(ControlFlowNode pred, ControlFlowNode succ) {
    succ = pred.getASuccessor() and
    not startsBB(succ)
  }

  /**
   * Holds if `cfn` is the `i`th node in basic block `bb`.
   *
   * In other words, `i` is the shortest distance from a node `bb`
   * that starts a basic block to `cfn` along the `intraBBSucc` relation.
   */
  cached
  predicate bbIndex(ControlFlowNode bbStart, ControlFlowNode cfn, int i) =
    shortestDistances(startsBB/1, intraBBSucc/2)(bbStart, cfn, i)
}

/**
 * Holds if the first node of basic block `succ` is a control flow
 * successor of the last node of basic block `pred`.
 */
private predicate succBB(BasicBlock pred, BasicBlock succ) { succ = pred.getASuccessor() }

/** Holds if `dom` is an immediate dominator of `bb`. */
predicate bbIDominates(BasicBlock dom, BasicBlock bb) = idominance(entryBB/1, succBB/2)(_, dom, bb)

/** Holds if `pred` is a basic block predecessor of `succ`. */
private predicate predBB(BasicBlock succ, BasicBlock pred) { succBB(pred, succ) }

/** Holds if `dom` is an immediate post-dominator of `bb`. */
predicate bbIPostDominates(BasicBlock dom, BasicBlock bb) =
  idominance(exitBB/1, predBB/2)(_, dom, bb)

/**
 * An entry basic block, that is, a basic block whose first node is
 * the entry node of a callable.
 */
class EntryBasicBlock extends BasicBlock {
  EntryBasicBlock() { entryBB(this) }
}

/** Holds if `bb` is an entry basic block. */
private predicate entryBB(BasicBlock bb) { bb.getFirstNode() instanceof EntryPoint }

/**
 * An exit basic block, that is, a basic block whose last node is
 * an exit node.
 */
class ExitBasicBlock extends BasicBlock {
  ExitBasicBlock() { exitBB(this) }
}

/** Holds if `bb` is an exit basic block. */
private predicate exitBB(BasicBlock bb) { not exists(bb.getLastNode().getASuccessor()) }

/**
 * A basic block with more than one predecessor.
 */
class JoinBlock extends BasicBlock {
  JoinBlock() { getFirstNode().isJoin() }
}

/** A basic block that terminates in a condition, splitting the subsequent control flow. */
class ConditionBlock extends BasicBlock {
  ConditionBlock() {
    exists(BasicBlock succ |
      succ = getATrueSuccessor()
      or
      succ = getAFalseSuccessor()
    )
  }

  /**
   * Holds if basic block `controlled` is controlled by this basic block with
   * Boolean value `testIsTrue`. That is, `controlled` can only be reached from
   * the callable entry point by going via the true edge (`testIsTrue = true`)
   * or false edge (`testIsTrue = false`) out of this basic block.
   */
  predicate controls(BasicBlock controlled, boolean testIsTrue) {
    /*
     * For this block to control the block `controlled` with `testIsTrue` the following must be true:
     * Execution must have passed through the test i.e. `this` must strictly dominate `controlled`.
     * Execution must have passed through the `testIsTrue` edge leaving `this`.
     *
     * Although "passed through the true edge" implies that `this.getATrueSuccessor()` dominates `controlled`,
     * the reverse is not true, as flow may have passed through another edge to get to `this.getATrueSuccessor()`
     * so we need to assert that `this.getATrueSuccessor()` dominates `controlled` *and* that
     * all predecessors of `this.getATrueSuccessor()` are either `this` or dominated by `this.getATrueSuccessor()`.
     *
     * For example, in the following C# snippet:
     * ```csharp
     * if (x)
     *   controlled;
     * false_successor;
     * uncontrolled;
     * ```
     * `false_successor` dominates `uncontrolled`, but not all of its predecessors are `this` (`if (x)`)
     *  or dominated by itself. Whereas in the following code:
     * ```csharp
     * if (x)
     *   while (controlled)
     *     also_controlled;
     * false_successor;
     * uncontrolled;
     * ```
     * the block `while controlled` is controlled because all of its predecessors are `this` (`if (x)`)
     * or (in the case of `also_controlled`) dominated by itself.
     *
     * The additional constraint on the predecessors of the test successor implies
     * that `this` strictly dominates `controlled` so that isn't necessary to check
     * directly.
     */

    exists(BasicBlock succ |
      isCandidateSuccessor(succ, testIsTrue) and
      succ.dominates(controlled)
    )
  }

  private predicate isCandidateSuccessor(BasicBlock succ, boolean testIsTrue) {
    (
      testIsTrue = true and succ = getATrueSuccessor()
      or
      testIsTrue = false and succ = getAFalseSuccessor()
    ) and
    forall(BasicBlock pred | pred = succ.getAPredecessor() and pred != this | succ.dominates(pred))
  }
}
