//
// NOTE: Maintain this file in synchrony with
// semmlecode-cpp-queries/semmle/code/cpp/controlflow/SubBasicBlocks.qll
//
// This is a private copy of the `SubBasicBlocks` library for internal use by
// the data flow library. Having an extra copy can prevent non-monotonic
// recursion errors in queries that use both the data flow library and the
// `SubBasicBlocks` library.

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
  BasicBlock getBasicBlock() {
    result = this.(ControlFlowNode).getBasicBlock()
  }

  /**
   * Holds if this `SubBasicBlock` comes first in its basic block. This is the
   * only condition under which a `SubBasicBlock` may have multiple
   * predecessors.
   */
  predicate firstInBB() {
    exists(BasicBlock bb | this.getPosInBasicBlock(bb) = 0)
  }

  /**
   * Holds if this `SubBasicBlock` comes last in its basic block. This is the
   * only condition under which a `SubBasicBlock` may have multiple successors.
   */
  predicate lastInBB() {
    exists(BasicBlock bb |
      this.getPosInBasicBlock(bb) = countSubBasicBlocksInBasicBlock(bb) - 1
    )
  }

  /**
   * Gets the position of this `SubBasicBlock` in its containing basic block
   * `bb`, where `bb` is equal to `getBasicBlock()`.
   */
  int getPosInBasicBlock(BasicBlock bb) {
    exists(int thisIndexInBB, int rnk |
      thisIndexInBB = this.getIndexInBasicBlock(bb) and
      thisIndexInBB = rank[rnk](int i | i = any(SubBasicBlock n).getIndexInBasicBlock(bb)) and
      result = rnk - 1
    )
  }

  pragma[noinline]
  private int getIndexInBasicBlock(BasicBlock bb) {
    this = bb.getNode(result)
  }

  /** Gets a successor in the control-flow graph of `SubBasicBlock`s. */
  SubBasicBlock getASuccessor() {
    this.lastInBB() and
    result = this.getBasicBlock().getASuccessor()
    or
    exists(BasicBlock bb |
      result.getPosInBasicBlock(bb) = this.getPosInBasicBlock(bb) + 1
    )
  }

  /**
   * Gets the `pos`th control-flow node in this `SubBasicBlock`. Positions
   * start from 0, and the node at position 0 always exists and compares equal
   * to `this`.
   */
  pragma[nomagic]
  ControlFlowNode getNode(int pos) {
    exists(BasicBlock bb |
      exists(int outerPos |
        result = bb.getNode(outerPos) and
        pos = outerPosToInnerPos(bb, outerPos)
      )
    )
  }

  pragma[nomagic]
  private int outerPosToInnerPos(BasicBlock bb, int posInBB) {
    posInBB = result + this.getIndexInBasicBlock(bb) and
    result = [ 0 .. this.getNumberOfNodes() - 1 ]
  }

  /** Gets a control-flow node in this `SubBasicBlock`. */
  ControlFlowNode getANode() {
    result = this.getNode(_)
  }

  /** Holds if `this` contains `node`. */
  predicate contains(ControlFlowNode node) {
    node = this.getANode()
  }

  /** Gets a predecessor in the control-flow graph of `SubBasicBlock`s. */
  SubBasicBlock getAPredecessor() {
    result.getASuccessor() = this
  }

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
  pragma[noopt]
  int getNumberOfNodes() {
    exists(BasicBlock bb | bb = this.getBasicBlock() |
      exists(int thisPos | this = bb.getNode(thisPos) |
        exists(int bbLength |
          this.lastInBB() and
          bbLength = bb.length() and
          result = bbLength - thisPos
        )
        or
        exists(SubBasicBlock succ, int succPos, int thisRank, int succRank |
          thisRank = this.getPosInBasicBlock(bb) and
          succRank = thisRank + 1 and
          succRank = succ.getPosInBasicBlock(bb) and
          bb.getNode(succPos) = succ and
          result = succPos - thisPos
        )
      )
    )
  }

  /** Gets the last control-flow node in this `SubBasicBlock`. */
  ControlFlowNode getEnd() {
    result = this.getNode(this.getNumberOfNodes() - 1)
  }

  /** Gets the first control-flow node in this `SubBasicBlock`. */
  ControlFlowNode getStart() {
    result = this
  }

  pragma[noinline]
  Function getEnclosingFunction() {
    result = this.getStart().getControlFlowScope()
  }
}

/** Gets the number of `SubBasicBlock`s in the given basic block. */
private int countSubBasicBlocksInBasicBlock(BasicBlock bb) {
  result = strictcount(SubBasicBlock sbb | sbb.getBasicBlock() = bb)
}
