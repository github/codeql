private import internal.IRInternal
import Instruction
import semmle.code.cpp.ir.implementation.EdgeKind
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
  final string toString() {
    result = getFirstInstruction(this).toString()
  }

  final Location getLocation() {
    result = getFirstInstruction().getLocation()
  }
  
  final string getUniqueId() {
    result = getFirstInstruction(this).getUniqueId()
  }
  
  /**
   * Gets the zero-based index of the block within its function. This is used
   * by debugging and printing code only.
   */
  int getDisplayIndex() {
    this = rank[result + 1](IRBlock funcBlock |
      funcBlock.getFunction() = getFunction() |
      funcBlock order by funcBlock.getUniqueId()
    )
  }

  final Instruction getInstruction(int index) {
    result = getInstruction(this, index)
  }

  final PhiInstruction getAPhiInstruction() {
    Construction::getPhiInstructionBlockStart(result) = getFirstInstruction()
  }

  final Instruction getAnInstruction() {
    result = getInstruction(_) or
    result = getAPhiInstruction()
  }

  final Instruction getFirstInstruction() {
    result = getFirstInstruction(this)
  }

  final Instruction getLastInstruction() {
    result = getInstruction(getInstructionCount() - 1)
  }

  final int getInstructionCount() {
    result = strictcount(getInstruction(_))
  }

  final FunctionIR getFunctionIR() {
    result = getFirstInstruction(this).getFunctionIR()
  }

  final Function getFunction() {
    result = getFirstInstruction(this).getFunction()
  }
}

/**
 * A basic block with additional information about its predecessor and successor edges. Each edge
 * corresponds to the control flow between the last instruction of one block and the first
 * instruction of another block.
 */
class IRBlock extends IRBlockBase {
  final IRBlock getASuccessor() {
    blockSuccessor(this, result)
  }

  final IRBlock getAPredecessor() {
    blockSuccessor(result, this)
  }

  final IRBlock getSuccessor(EdgeKind kind) {
    blockSuccessor(this, result, kind)
  }

  final predicate immediatelyDominates(IRBlock block) {
    blockImmediatelyDominates(this, block)
  }

  final predicate strictlyDominates(IRBlock block) {
    blockImmediatelyDominates+(this, block)
  }

  final predicate dominates(IRBlock block) {
    strictlyDominates(block) or this = block
  }

  pragma[noinline]
  final IRBlock dominanceFrontier() {
    dominates(result.getAPredecessor()) and
    not strictlyDominates(result)
  }
  
  /**
   * Holds if this block is reachable from the entry point of its function
   */
  final predicate isReachableFromFunctionEntry() {
    this = getFunctionIR().getEntryBlock() or
    getAPredecessor().isReachableFromFunctionEntry()
  }
}

private predicate startsBasicBlock(Instruction instr) {
  not instr instanceof PhiInstruction and
  (
    count(Instruction predecessor |
      instr = predecessor.getASuccessor()
    ) != 1 or  // Multiple predecessors or no predecessor
    exists(Instruction predecessor |
      instr = predecessor.getASuccessor() and
      strictcount(Instruction other |
        other = predecessor.getASuccessor()
      ) > 1
    ) or  // Predecessor has multiple successors
    exists(Instruction predecessor, EdgeKind kind |
      instr = predecessor.getSuccessor(kind) and
      not kind instanceof GotoEdge
    )  // Incoming edge is not a GotoEdge
  )
}

private predicate isEntryBlock(TIRBlock block) {
  block = MkIRBlock(any(EnterFunctionInstruction enter))
}

private cached module Cached {
  cached newtype TIRBlock =
    MkIRBlock(Instruction firstInstr) {
      startsBasicBlock(firstInstr)
    }

  /** Holds if `i2` follows `i1` in a `IRBlock`. */
  private predicate adjacentInBlock(Instruction i1, Instruction i2) {
    exists(GotoEdge edgeKind | i2 = i1.getSuccessor(edgeKind)) and
    not startsBasicBlock(i2)
  }

  /** Gets the index of `i` in its `IRBlock`. */
  private int getMemberIndex(Instruction i) {
    startsBasicBlock(i) and
    result = 0
    or
    exists(Instruction iPrev |
      adjacentInBlock(iPrev, i) and
      result = getMemberIndex(iPrev) + 1
    )
  }

  /** Holds if `i` is the `index`th instruction in `block`. */
  cached Instruction getInstruction(TIRBlock block, int index) {
    exists(Instruction first |
      block = MkIRBlock(first) and
      index = getMemberIndex(result) and
      adjacentInBlock*(first, result)
    )
  }

  cached int getInstructionCount(TIRBlock block) {
    result = strictcount(getInstruction(block, _))
  }

  cached predicate blockSuccessor(TIRBlock pred, TIRBlock succ, EdgeKind kind) {
    exists(Instruction predLast, Instruction succFirst |
      predLast = getInstruction(pred, getInstructionCount(pred) - 1) and
      succFirst = predLast.getSuccessor(kind) and
      succ = MkIRBlock(succFirst)
    )
  }

  cached predicate blockSuccessor(TIRBlock pred, TIRBlock succ) {
    blockSuccessor(pred, succ, _)
  }

  cached predicate blockImmediatelyDominates(TIRBlock dominator, TIRBlock block) =
    idominance(isEntryBlock/1, blockSuccessor/2)(_, dominator, block)
}

Instruction getFirstInstruction(TIRBlock block) {
  block = MkIRBlock(result)
}
