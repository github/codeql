private import IRInternal
import Instruction
import cpp
import semmle.code.cpp.ir.EdgeKind

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

private import Cached
private cached module Cached {
  cached newtype TIRBlock =
    MkIRBlock(Instruction firstInstr) {
      startsBasicBlock(firstInstr)
    }

  cached Instruction getInstruction(TIRBlock block, int index) {
    index = 0 and block = MkIRBlock(result) or
    (
      index > 0 and
      not startsBasicBlock(result) and
      exists(Instruction predecessor, GotoEdge edge |
        predecessor = getInstruction(block, index - 1) and
        result = predecessor.getSuccessor(edge)
      )
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

class IRBlock extends TIRBlock {
  Instruction firstInstr;

  IRBlock() {
    this = MkIRBlock(firstInstr)
  }

  final string toString() {
    result = firstInstr.toString()
  }

  final Location getLocation() {
    result = getFirstInstruction().getLocation()
  }
  
  final string getUniqueId() {
    result = firstInstr.getUniqueId()
  }
  
  final Instruction getInstruction(int index) {
    result = getInstruction(this, index)
  }

  final PhiInstruction getAPhiInstruction() {
    Construction::getPhiInstructionBlockStart(result) =
      getFirstInstruction()
  }

  final Instruction getAnInstruction() {
    result = getInstruction(_) or
    result = getAPhiInstruction()
  }

  final Instruction getFirstInstruction() {
    result = firstInstr
  }

  final Instruction getLastInstruction() {
    result = getInstruction(getInstructionCount() - 1)
  }

  final int getInstructionCount() {
    result = strictcount(getInstruction(_))
  }

  final FunctionIR getFunctionIR() {
    result = firstInstr.getFunctionIR()
  }

  final Function getFunction() {
    result = firstInstr.getFunction()
  }

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
}
