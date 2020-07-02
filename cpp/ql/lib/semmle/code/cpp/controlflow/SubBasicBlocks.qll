// NOTE: There are two copies of this file, and they must be kept identical:
// - semmle/code/cpp/controlflow/SubBasicBlocks.qll
// - semmle/code/cpp/dataflow/internal/SubBasicBlocks.qll
//
// The second one is a private copy of the `SubBasicBlocks` library for
// internal use by the data flow library. Having an extra copy prevents
// non-monotonic recursion errors in queries that use both the data flow
// library and the `SubBasicBlocks` library.
/**
 * Provides the `SubBasicBlock` class, used for partitioning basic blocks in
 * smaller pieces.
 */

import cpp

/**
 * An abstract class that directs where in the control-flow graph a new
 * `SubBasicBlock` must start. If a `ControlFlowNode` is an instance of this
 * class, that node is guaranteed to be the first node in a `SubBasicBlock`.
 * If multiple libraries use the `SubBasicBlock` library, basic blocks may be
 * split in more places than either library expects, but nothing should break
 * as a direct result of that.
 */
abstract class SubBasicBlockCutNode extends ControlFlowNode {
  SubBasicBlockCutNode() {
    // Some control-flow nodes are not in any basic block. This includes
    // `Conversion`s, expressions that are evaluated at compile time, default
    // arguments, and `Function`s without implementation.
    exists(this.getBasicBlock())
  }
}

/**
 * A block that can be smaller than or equal to a `BasicBlock`. Use this class
 * when `ControlFlowNode` is too fine-grained and `BasicBlock` too
 * coarse-grained. Their successor graph is like that of basic blocks, except
 * that the blocks are split up with an extra edge right before any instance of
 * the abstract class `SubBasicBlockCutNode`. Users of this library must
 * therefore extend `SubBasicBlockCutNode` to direct where basic blocks will be
 * split up.
 */
class SubBasicBlock extends ControlFlowNodeBase {
  SubBasicBlock() {
    this instanceof BasicBlock
    or
    this instanceof SubBasicBlockCutNode
  }

  /** Gets the basic block in which this `SubBasicBlock` is contained. */
  BasicBlock getBasicBlock() { result = this.(ControlFlowNode).getBasicBlock() }

  /**
   * Holds if this `SubBasicBlock` comes first in its basic block. This is the
   * only condition under which a `SubBasicBlock` may have multiple
   * predecessors.
   */
  predicate firstInBB() { exists(BasicBlock bb | this.getRankInBasicBlock(bb) = 1) }

  /**
   * Holds if this `SubBasicBlock` comes last in its basic block. This is the
   * only condition under which a `SubBasicBlock` may have multiple successors.
   */
  predicate lastInBB() {
    exists(BasicBlock bb | this.getRankInBasicBlock(bb) = countSubBasicBlocksInBasicBlock(bb))
  }

  /**
   * Gets the (1-based) rank of this `SubBasicBlock` among the other `SubBasicBlock`s in
   * its containing basic block `bb`, where `bb` is equal to `getBasicBlock()`.
   */
  int getRankInBasicBlock(BasicBlock bb) {
    exists(int thisIndexInBB |
      thisIndexInBB = this.getIndexInBasicBlock(bb) and
      thisIndexInBB = rank[result](int i | i = any(SubBasicBlock n).getIndexInBasicBlock(bb))
    )
  }

  /**
   * DEPRECATED: use `getRankInBasicBlock` instead. Note that this predicate
   * returns a 0-based position, while `getRankInBasicBlock` returns a 1-based
   * position.
   */
  deprecated int getPosInBasicBlock(BasicBlock bb) { result = getRankInBasicBlock(bb) - 1 }

  pragma[noinline]
  private int getIndexInBasicBlock(BasicBlock bb) { this = bb.getNode(result) }

  /** Gets a successor in the control-flow graph of `SubBasicBlock`s. */
  SubBasicBlock getASuccessor() {
    this.lastInBB() and
    result = this.getBasicBlock().getASuccessor()
    or
    exists(BasicBlock bb | result.getRankInBasicBlock(bb) = this.getRankInBasicBlock(bb) + 1)
  }

  /**
   * Gets the `index`th control-flow node in this `SubBasicBlock`. Indexes
   * start from 0, and the node at index 0 always exists and compares equal
   * to `this`.
   */
  ControlFlowNode getNode(int index) {
    exists(BasicBlock bb |
      exists(int outerIndex |
        result = bb.getNode(outerIndex) and
        index = outerToInnerIndex(bb, outerIndex)
      )
    )
  }

  /**
   * Gets the index of the node in this `SubBasicBlock` that has `indexInBB` in
   * `bb`, where `bb` is equal to `getBasicBlock()`.
   */
  // This predicate is factored out of `getNode` to ensure a good join order.
  // It's sensitive to bad magic, so it has `pragma[nomagic]` on it. For
  // example, it can get very slow if `getNode` is pragma[nomagic], which could
  // mean it might get very slow if `getNode` is used in the wrong context.
  pragma[nomagic]
  private int outerToInnerIndex(BasicBlock bb, int indexInBB) {
    indexInBB = result + this.getIndexInBasicBlock(bb) and
    result = [0 .. this.getNumberOfNodes() - 1]
  }

  /** Gets a control-flow node in this `SubBasicBlock`. */
  ControlFlowNode getANode() { result = this.getNode(_) }

  /** Holds if `this` contains `node`. */
  predicate contains(ControlFlowNode node) { node = this.getANode() }

  /** Gets a predecessor in the control-flow graph of `SubBasicBlock`s. */
  SubBasicBlock getAPredecessor() { result.getASuccessor() = this }

  /**
   * Gets a node such that the control-flow edge `(this, result)` may be taken
   * when the final node of this `SubBasicBlock` is a conditional expression
   * and evaluates to true.
   */
  SubBasicBlock getATrueSuccessor() {
    this.lastInBB() and
    result = this.getBasicBlock().getATrueSuccessor()
  }

  /**
   * Gets a node such that the control-flow edge `(this, result)` may be taken
   * when the final node of this `SubBasicBlock` is a conditional expression
   * and evaluates to false.
   */
  SubBasicBlock getAFalseSuccessor() {
    this.lastInBB() and
    result = this.getBasicBlock().getAFalseSuccessor()
  }

  /**
   * Gets the number of control-flow nodes in this `SubBasicBlock`. There is
   * always at least one.
   */
  int getNumberOfNodes() {
    exists(BasicBlock bb |
      if this.lastInBB()
      then result = bb.length() - this.getIndexInBasicBlock(bb)
      else result = this.getASuccessor().getIndexInBasicBlock(bb) - this.getIndexInBasicBlock(bb)
    )
  }

  /** Gets the last control-flow node in this `SubBasicBlock`. */
  ControlFlowNode getEnd() { result = this.getNode(this.getNumberOfNodes() - 1) }

  /** Gets the first control-flow node in this `SubBasicBlock`. */
  ControlFlowNode getStart() { result = this }

  /** Gets the function that contains this `SubBasicBlock`. */
  pragma[noinline]
  Function getEnclosingFunction() { result = this.getStart().getControlFlowScope() }
}

/** Gets the number of `SubBasicBlock`s in the given basic block. */
private int countSubBasicBlocksInBasicBlock(BasicBlock bb) {
  result = strictcount(SubBasicBlock sbb | sbb.getBasicBlock() = bb)
}
