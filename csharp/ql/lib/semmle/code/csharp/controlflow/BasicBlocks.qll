/**
 * Provides classes representing basic blocks.
 */

import csharp
private import ControlFlow::SuccessorTypes

/**
 * A basic block, that is, a maximal straight-line sequence of control flow nodes
 * without branches or joins.
 */
class BasicBlock extends TBasicBlockStart {
  /** Gets an immediate successor of this basic block, if any. */
  BasicBlock getASuccessor() { result.getFirstNode() = this.getLastNode().getASuccessor() }

  /** Gets an immediate successor of this basic block of a given type, if any. */
  BasicBlock getASuccessorByType(ControlFlow::SuccessorType t) {
    result.getFirstNode() = this.getLastNode().getASuccessorByType(t)
  }

  /** Gets an immediate predecessor of this basic block, if any. */
  BasicBlock getAPredecessor() { result.getASuccessor() = this }

  /** Gets an immediate predecessor of this basic block of a given type, if any. */
  BasicBlock getAPredecessorByType(ControlFlow::SuccessorType t) {
    result.getASuccessorByType(t) = this
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
  ControlFlow::Node getNode(int pos) { bbIndex(this.getFirstNode(), result, pos) }

  /** Gets a control flow node in this basic block. */
  ControlFlow::Node getANode() { result = this.getNode(_) }

  /** Gets the first control flow node in this basic block. */
  ControlFlow::Node getFirstNode() { this = TBasicBlockStart(result) }

  /** Gets the last control flow node in this basic block. */
  ControlFlow::Node getLastNode() { result = this.getNode(this.length() - 1) }

  /** Gets the callable that this basic block belongs to. */
  final Callable getCallable() { result = this.getFirstNode().getEnclosingCallable() }

  /** Gets the length of this basic block. */
  int length() { result = strictcount(this.getANode()) }

  /**
   * Holds if this basic block immediately dominates basic block `bb`.
   *
   * That is, all paths reaching basic block `bb` from some entry point
   * basic block must go through this basic block (which is an immediate
   * predecessor of `bb`).
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
  predicate immediatelyDominates(BasicBlock bb) { bbIDominates(this, bb) }

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
  predicate inDominanceFrontier(BasicBlock df) {
    this.dominatesPredecessor(df) and
    not this.strictlyDominates(df)
  }

  /**
   * Holds if this basic block dominates a predecessor of `df`.
   */
  private predicate dominatesPredecessor(BasicBlock df) { this.dominates(df.getAPredecessor()) }

  /**
   * Gets the basic block that immediately dominates this basic block, if any.
   *
   * That is, all paths reaching this basic block from some entry point
   * basic block must go through the result.
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
  BasicBlock getImmediateDominator() { bbIDominates(result, this) }

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
  predicate strictlyPostDominates(BasicBlock bb) { bbIPostDominates+(this, bb) }

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
  predicate postDominates(BasicBlock bb) {
    this.strictlyPostDominates(bb) or
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
  string toString() { result = this.getFirstNode().toString() }

  /** Gets the location of this basic block. */
  Location getLocation() { result = this.getFirstNode().getLocation() }
}

/**
 * Internal implementation details.
 */
cached
private module Internal {
  /** Internal representation of basic blocks. */
  cached
  newtype TBasicBlock = TBasicBlockStart(ControlFlow::Node cfn) { startsBB(cfn) }

  /** Holds if `cfn` starts a new basic block. */
  private predicate startsBB(ControlFlow::Node cfn) {
    not exists(cfn.getAPredecessor()) and exists(cfn.getASuccessor())
    or
    cfn.isJoin()
    or
    cfn.getAPredecessor().isBranch()
    or
    /*
     * In cases such as
     * ```csharp
     * if (b)
     *     M()
     * ```
     * where the `false` edge out of `b` is not present (because we can prove it
     * impossible), we still split up the basic block in two, in order to generate
     * a `ConditionBlock` which can be used by the guards library.
     */

    exists(cfn.getAPredecessorByType(any(ControlFlow::SuccessorTypes::ConditionalSuccessor s)))
  }

  /**
   * Holds if `succ` is a control flow successor of `pred` within
   * the same basic block.
   */
  private predicate intraBBSucc(ControlFlow::Node pred, ControlFlow::Node succ) {
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
  predicate bbIndex(ControlFlow::Node bbStart, ControlFlow::Node cfn, int i) =
    shortestDistances(startsBB/1, intraBBSucc/2)(bbStart, cfn, i)

  /**
   * Holds if the first node of basic block `succ` is a control flow
   * successor of the last node of basic block `pred`.
   */
  private predicate succBB(BasicBlock pred, BasicBlock succ) { succ = pred.getASuccessor() }

  /** Holds if `dom` is an immediate dominator of `bb`. */
  cached
  predicate bbIDominates(BasicBlock dom, BasicBlock bb) =
    idominance(entryBB/1, succBB/2)(_, dom, bb)

  /** Holds if `pred` is a basic block predecessor of `succ`. */
  private predicate predBB(BasicBlock succ, BasicBlock pred) { succBB(pred, succ) }

  /** Holds if `bb` is an exit basic block that represents normal exit. */
  private predicate normalExitBB(BasicBlock bb) {
    bb.getANode().(ControlFlow::Nodes::AnnotatedExitNode).isNormal()
  }

  /** Holds if `dom` is an immediate post-dominator of `bb`. */
  cached
  predicate bbIPostDominates(BasicBlock dom, BasicBlock bb) =
    idominance(normalExitBB/1, predBB/2)(_, dom, bb)
}

private import Internal

/**
 * An entry basic block, that is, a basic block whose first node is
 * the entry node of a callable.
 */
class EntryBasicBlock extends BasicBlock {
  EntryBasicBlock() { entryBB(this) }
}

/** Holds if `bb` is an entry basic block. */
private predicate entryBB(BasicBlock bb) {
  bb.getFirstNode() instanceof ControlFlow::Nodes::EntryNode
}

/**
 * An annotated exit basic block, that is, a basic block that contains
 * an annotated exit node.
 */
class AnnotatedExitBasicBlock extends BasicBlock {
  private boolean isNormal;

  AnnotatedExitBasicBlock() {
    this.getANode() =
      any(ControlFlow::Nodes::AnnotatedExitNode n |
        if n.isNormal() then isNormal = true else isNormal = false
      )
  }

  /** Holds if this block represents a normal exit. */
  predicate isNormal() { isNormal = true }
}

/**
 * An exit basic block, that is, a basic block whose last node is
 * the exit node of a callable.
 */
class ExitBasicBlock extends BasicBlock {
  ExitBasicBlock() { this.getLastNode() instanceof ControlFlow::Nodes::ExitNode }
}

private module JoinBlockPredecessors {
  private import ControlFlow::Nodes
  private import semmle.code.csharp.controlflow.internal.ControlFlowGraphImpl

  int getId(JoinBlockPredecessor jbp) {
    exists(ControlFlowTree::Range_ t | ControlFlowTree::idOf(t, result) |
      t = jbp.getFirstNode().getElement()
      or
      t = jbp.(EntryBasicBlock).getCallable()
    )
  }

  string getSplitString(JoinBlockPredecessor jbp) {
    result = jbp.getFirstNode().(ElementNode).getSplitsString()
    or
    not exists(jbp.getFirstNode().(ElementNode).getSplitsString()) and
    result = ""
  }
}

/** A basic block with more than one predecessor. */
class JoinBlock extends BasicBlock {
  JoinBlock() { this.getFirstNode().isJoin() }

  /**
   * Gets the `i`th predecessor of this join block, with respect to some
   * arbitrary order.
   */
  cached
  JoinBlockPredecessor getJoinBlockPredecessor(int i) {
    result =
      rank[i + 1](JoinBlockPredecessor jbp |
        jbp = this.getAPredecessor()
      |
        jbp order by JoinBlockPredecessors::getId(jbp), JoinBlockPredecessors::getSplitString(jbp)
      )
  }
}

/** A basic block that is an immediate predecessor of a join block. */
class JoinBlockPredecessor extends BasicBlock {
  JoinBlockPredecessor() { this.getASuccessor() instanceof JoinBlock }
}

/** A basic block that terminates in a condition, splitting the subsequent control flow. */
class ConditionBlock extends BasicBlock {
  ConditionBlock() { this.getLastNode().isCondition() }

  /**
   * Holds if basic block `succ` is immediately controlled by this basic
   * block with conditional value `s`. That is, `succ` is an immediate
   * successor of this block, and `succ` can only be reached from
   * the callable entry point by going via the `s` edge out of this basic block.
   */
  pragma[nomagic]
  predicate immediatelyControls(BasicBlock succ, ConditionalSuccessor s) {
    succ = this.getASuccessorByType(s) and
    forall(BasicBlock pred | pred = succ.getAPredecessor() and pred != this | succ.dominates(pred))
  }

  /**
   * Holds if basic block `controlled` is controlled by this basic block with
   * conditional value `s`. That is, `controlled` can only be reached from
   * the callable entry point by going via the `s` edge out of this basic block.
   */
  predicate controls(BasicBlock controlled, ConditionalSuccessor s) {
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

    exists(BasicBlock succ | this.immediatelyControls(succ, s) | succ.dominates(controlled))
  }
}
