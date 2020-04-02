private import internal.IRInternal
import Instruction
private import internal.IRBlockImports as Imports
import Imports::EdgeKind
private import Cached

/**
 * A basic block in the IR. A basic block consists of a sequence of `Instructions` with the only
 * incoming edges at the beginning of the sequence and the only outgoing edges at the end of the
 * sequence.
 *
 * This class does not contain any members that query the predecessor or successor edges of the
 * block. This allows different classes that extend `IRBlockBase` to expose different subsets of
 * edges (e.g. ignoring unreachable edges).
 *
 * Most consumers should use the class `IRBlock`.
 */
class IRBlockBase extends TIRBlock {
  final string toString() { result = getFirstInstruction(this).toString() }

  final Language::Location getLocation() { result = getFirstInstruction().getLocation() }

  final string getUniqueId() { result = getFirstInstruction(this).getUniqueId() }

  /**
   * Gets the zero-based index of the block within its function. This is used
   * by debugging and printing code only.
   */
  int getDisplayIndex() {
    exists(IRConfiguration::IRConfiguration config |
      config.shouldEvaluateDebugStringsForFunction(this.getEnclosingFunction())
    ) and
    this =
      rank[result + 1](IRBlock funcBlock |
        funcBlock.getEnclosingFunction() = getEnclosingFunction()
      |
        funcBlock order by funcBlock.getUniqueId()
      )
  }

  final Instruction getInstruction(int index) { result = getInstruction(this, index) }

  final PhiInstruction getAPhiInstruction() {
    Construction::getPhiInstructionBlockStart(result) = getFirstInstruction()
  }

  final Instruction getAnInstruction() {
    result = getInstruction(_) or
    result = getAPhiInstruction()
  }

  final Instruction getFirstInstruction() { result = getFirstInstruction(this) }

  final Instruction getLastInstruction() { result = getInstruction(getInstructionCount() - 1) }

  final int getInstructionCount() { result = getInstructionCount(this) }

  final IRFunction getEnclosingIRFunction() {
    result = getFirstInstruction(this).getEnclosingIRFunction()
  }

  final Language::Function getEnclosingFunction() {
    result = getFirstInstruction(this).getEnclosingFunction()
  }
}

/**
 * A basic block with additional information about its predecessor and successor edges. Each edge
 * corresponds to the control flow between the last instruction of one block and the first
 * instruction of another block.
 */
class IRBlock extends IRBlockBase {
  final IRBlock getASuccessor() { blockSuccessor(this, result) }

  final IRBlock getAPredecessor() { blockSuccessor(result, this) }

  final IRBlock getSuccessor(EdgeKind kind) { blockSuccessor(this, result, kind) }

  final IRBlock getBackEdgeSuccessor(EdgeKind kind) { backEdgeSuccessor(this, result, kind) }

  final predicate immediatelyDominates(IRBlock block) { blockImmediatelyDominates(this, block) }

  final predicate strictlyDominates(IRBlock block) { blockImmediatelyDominates+(this, block) }

  final predicate dominates(IRBlock block) { strictlyDominates(block) or this = block }

  pragma[noinline]
  final IRBlock dominanceFrontier() {
    dominates(result.getAPredecessor()) and
    not strictlyDominates(result)
  }

  /**
   * Holds if this block is reachable from the entry point of its function
   */
  final predicate isReachableFromFunctionEntry() {
    this = getEnclosingIRFunction().getEntryBlock() or
    getAPredecessor().isReachableFromFunctionEntry()
  }
}

private predicate startsBasicBlock(Instruction instr) {
  not instr instanceof PhiInstruction and
  (
    count(Instruction predecessor | instr = predecessor.getASuccessor()) != 1 // Multiple predecessors or no predecessor
    or
    exists(Instruction predecessor |
      instr = predecessor.getASuccessor() and
      strictcount(Instruction other | other = predecessor.getASuccessor()) > 1
    ) // Predecessor has multiple successors
    or
    exists(Instruction predecessor, EdgeKind kind |
      instr = predecessor.getSuccessor(kind) and
      not kind instanceof GotoEdge
    ) // Incoming edge is not a GotoEdge
    or
    exists(Instruction predecessor |
      instr = Construction::getInstructionBackEdgeSuccessor(predecessor, _)
    ) // A back edge enters this instruction
  )
}

private predicate isEntryBlock(TIRBlock block) {
  block = MkIRBlock(any(EnterFunctionInstruction enter))
}

cached
private module Cached {
  cached
  newtype TIRBlock = MkIRBlock(Instruction firstInstr) { startsBasicBlock(firstInstr) }

  /** Holds if `i2` follows `i1` in a `IRBlock`. */
  private predicate adjacentInBlock(Instruction i1, Instruction i2) {
    exists(GotoEdge edgeKind | i2 = i1.getSuccessor(edgeKind)) and
    not startsBasicBlock(i2)
  }

  /** Holds if `i` is the `index`th instruction the block starting with `first`. */
  private Instruction getInstructionFromFirst(Instruction first, int index) =
    shortestDistances(startsBasicBlock/1, adjacentInBlock/2)(first, result, index)

  /** Holds if `i` is the `index`th instruction in `block`. */
  cached
  Instruction getInstruction(TIRBlock block, int index) {
    result = getInstructionFromFirst(getFirstInstruction(block), index)
  }

  cached
  int getInstructionCount(TIRBlock block) { result = strictcount(getInstruction(block, _)) }

  cached
  predicate blockSuccessor(TIRBlock pred, TIRBlock succ, EdgeKind kind) {
    exists(Instruction predLast, Instruction succFirst |
      predLast = getInstruction(pred, getInstructionCount(pred) - 1) and
      succFirst = predLast.getSuccessor(kind) and
      succ = MkIRBlock(succFirst)
    )
  }

  pragma[noinline]
  private predicate blockIdentity(TIRBlock b1, TIRBlock b2) { b1 = b2 }

  pragma[noopt]
  cached
  predicate backEdgeSuccessor(TIRBlock pred, TIRBlock succ, EdgeKind kind) {
    backEdgeSuccessorRaw(pred, succ, kind)
    or
    // See the QLDoc on `backEdgeSuccessorRaw`.
    exists(TIRBlock pred2 |
      // Joining with `blockIdentity` is a performance trick to get
      // `forwardEdgeRaw` on the RHS of a join, where it's fast.
      blockIdentity(pred, pred2) and
      forwardEdgeRaw+(pred, pred2)
    ) and
    blockSuccessor(pred, succ, kind)
  }

  /**
   * Holds if there is an edge from `pred` to `succ` that is not a back edge.
   */
  private predicate forwardEdgeRaw(TIRBlock pred, TIRBlock succ) {
    exists(EdgeKind kind |
      blockSuccessor(pred, succ, kind) and
      not backEdgeSuccessorRaw(pred, succ, kind)
    )
  }

  /**
   * Holds if the `kind`-edge from `pred` to `succ` is a back edge according to
   * `Construction`.
   *
   * There could be loops of non-back-edges if there is a flaw in the IR
   * construction or back-edge detection, and this could cause non-termination
   * of subsequent analysis. To prevent that, a subsequent predicate further
   * classifies all edges as back edges if they are involved in a loop of
   * non-back-edges.
   */
  private predicate backEdgeSuccessorRaw(TIRBlock pred, TIRBlock succ, EdgeKind kind) {
    exists(Instruction predLast, Instruction succFirst |
      predLast = getInstruction(pred, getInstructionCount(pred) - 1) and
      succFirst = Construction::getInstructionBackEdgeSuccessor(predLast, kind) and
      succ = MkIRBlock(succFirst)
    )
  }

  cached
  predicate blockSuccessor(TIRBlock pred, TIRBlock succ) { blockSuccessor(pred, succ, _) }

  cached
  predicate blockImmediatelyDominates(TIRBlock dominator, TIRBlock block) =
    idominance(isEntryBlock/1, blockSuccessor/2)(_, dominator, block)
}

Instruction getFirstInstruction(TIRBlock block) { block = MkIRBlock(result) }
