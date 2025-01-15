/**
 * This modules provides an implementation of a basic block class based based
 * on a control flow graph implementation.
 *
 * INTERNAL use only. This is an experimental API subject to change without
 * notice.
 */

/** Provides the language-specific input specification. */
signature module InputSig {
  class SuccessorType;

  /** Hold if `t` represents a conditional successor type. */
  predicate successorTypeIsCondition(SuccessorType t);

  /** The class of control flow nodes. */
  class Node {
    string toString();
  }

  Node nodeGetASuccessor(Node node, SuccessorType t);

  /** Holds if `node` is the beginning of an entry basic block. */
  predicate nodeIsEntry(Node node);

  /** Holds if `node` is the beginning of an entry basic block. */
  predicate nodeIsExit(Node node);
}

/**
 * Provides a basic block construction on top of a control flow graph.
 */
module Make<InputSig Input> {
  private import Input

  final class BasicBlock = BasicBlockImpl;

  private Node nodeGetAPredecessor(Node node, SuccessorType s) {
    nodeGetASuccessor(result, s) = node
  }

  /** Holds if this node has more than one predecessor. */
  private predicate nodeIsJoin(Node node) { strictcount(nodeGetAPredecessor(node, _)) > 1 }

  private predicate nodeIsBranch(Node node) { strictcount(nodeGetASuccessor(node, _)) > 1 }

  /**
   * A basic block, that is, a maximal straight-line sequence of control flow nodes
   * without branches or joins.
   */
  private class BasicBlockImpl extends TBasicBlockStart {
    /** Gets an immediate successor of this basic block, if any. */
    BasicBlock getASuccessor() { result = this.getASuccessor(_) }

    /** Gets an immediate successor of this basic block of a given type, if any. */
    BasicBlock getASuccessor(SuccessorType t) {
      result.getFirstNode() = nodeGetASuccessor(this.getLastNode(), t)
    }

    /** Gets an immediate predecessor of this basic block, if any. */
    BasicBlock getAPredecessor() { result.getASuccessor(_) = this }

    /** Gets an immediate predecessor of this basic block of a given type, if any. */
    BasicBlock getAPredecessor(SuccessorType t) { result.getASuccessor(t) = this }

    /** Gets the control flow node at a specific (zero-indexed) position in this basic block. */
    Node getNode(int pos) { bbIndex(this.getFirstNode(), result, pos) }

    /** Gets a control flow node in this basic block. */
    Node getANode() { result = this.getNode(_) }

    /** Gets the first control flow node in this basic block. */
    Node getFirstNode() { this = TBasicBlockStart(result) }

    /** Gets the last control flow node in this basic block. */
    Node getLastNode() { result = this.getNode(this.length() - 1) }

    /** Gets the length of this basic block. */
    int length() { result = strictcount(this.getANode()) }

    /**
     * Holds if this basic block immediately dominates basic block `bb`.
     *
     * That is, `bb` is an immediate successor of this basic block and all
     * paths reaching basic block `bb` from some entry point basic block must
     * go through this basic block.
     */
    predicate immediatelyDominates(BasicBlock bb) { bbIDominates(this, bb) }

    /**
     * Holds if this basic block strictly dominates basic block `bb`.
     *
     * That is, all paths reaching `bb` from some entry point basic block must
     * go through this basic block and this basic block is different from `bb`.
     */
    predicate strictlyDominates(BasicBlock bb) { bbIDominates+(this, bb) }

    /**
     * Holds if this basic block dominates basic block `bb`.
     *
     * That is, all paths reaching `bb` from some entry point basic block must
     * go through this basic block.
     */
    predicate dominates(BasicBlock bb) {
      bb = this or
      this.strictlyDominates(bb)
    }

    /**
     * Holds if `df` is in the dominance frontier of this basic block. That is,
     * this basic block dominates a predecessor of `df`, but does not dominate
     * `df` itself.
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
     * basic block must go through the result, which is an immediate basic block
     * predecessor of this basic block.
     */
    BasicBlock getImmediateDominator() { bbIDominates(result, this) }

    /**
     * Holds if this basic block strictly post-dominates basic block `bb`.
     *
     * That is, all paths reaching a normal exit point basic block from basic
     * block `bb` must go through this basic block and this basic block is
     * different from `bb`.
     */
    predicate strictlyPostDominates(BasicBlock bb) { bbIPostDominates+(this, bb) }

    /**
     * Holds if this basic block post-dominates basic block `bb`.
     *
     * That is, all paths reaching a normal exit point basic block from basic
     * block `bb` must go through this basic block.
     */
    predicate postDominates(BasicBlock bb) {
      this.strictlyPostDominates(bb) or
      this = bb
    }

    /** Holds if this basic block is in a loop in the control flow graph. */
    predicate inLoop() { this.getASuccessor+() = this }

    /** Gets a textual representation of this basic block. */
    string toString() { result = this.getFirstNode().toString() }
  }

  cached
  private module Cached {
    /**
     * Internal representation of basic blocks. A basic block is represented
     * by its first CFG node.
     */
    cached
    newtype TBasicBlock = TBasicBlockStart(Node cfn) { startsBB(cfn) }

    /** Holds if `cfn` starts a new basic block. */
    private predicate startsBB(Node cfn) {
      not exists(nodeGetAPredecessor(cfn, _)) and exists(nodeGetASuccessor(cfn, _))
      or
      nodeIsJoin(cfn)
      or
      nodeIsBranch(nodeGetAPredecessor(cfn, _))
      or
      // In cases such as
      //
      // ```rb
      // if x or y
      //     foo
      // else
      //     bar
      // ```
      //
      // we have a CFG that looks like
      //
      // x --false--> [false] x or y --false--> bar
      // \                    |
      //  --true--> y --false--
      //            \
      //             --true--> [true] x or y --true--> foo
      //
      // and we want to ensure that both `foo` and `bar` start a new basic block.
      exists(nodeGetAPredecessor(cfn, any(SuccessorType s | successorTypeIsCondition(s))))
    }

    /**
     * Holds if `succ` is a control flow successor of `pred` within
     * the same basic block.
     */
    private predicate intraBBSucc(Node pred, Node succ) {
      succ = nodeGetASuccessor(pred, _) and
      not startsBB(succ)
    }

    /**
     * Holds if `bbStart` is the first node in a basic block and `cfn` is the
     * `i`th node in the same basic block.
     */
    cached
    predicate bbIndex(Node bbStart, Node cfn, int i) =
      shortestDistances(startsBB/1, intraBBSucc/2)(bbStart, cfn, i)

    /**
     * Holds if the first node of basic block `succ` is a control flow
     * successor of the last node of basic block `pred`.
     */
    private predicate succBB(BasicBlock pred, BasicBlock succ) { pred.getASuccessor(_) = succ }

    /** Holds if `dom` is an immediate dominator of `bb`. */
    cached
    predicate bbIDominates(BasicBlock dom, BasicBlock bb) =
      idominance(entryBB/1, succBB/2)(_, dom, bb)

    /** Holds if `pred` is a basic block predecessor of `succ`. */
    private predicate predBB(BasicBlock succ, BasicBlock pred) { succBB(pred, succ) }

    /** Holds if `bb` is an exit basic block that represents normal exit. */
    private predicate exitBB(BasicBlock bb) { nodeIsExit(bb.getANode()) }

    /** Holds if `dom` is an immediate post-dominator of `bb`. */
    cached
    predicate bbIPostDominates(BasicBlock dom, BasicBlock bb) =
      idominance(exitBB/1, predBB/2)(_, dom, bb)
  }

  private import Cached

  /** Holds if `bb` is an entry basic block. */
  private predicate entryBB(BasicBlock bb) { nodeIsEntry(bb.getFirstNode()) }
}
