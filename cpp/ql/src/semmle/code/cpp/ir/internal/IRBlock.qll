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

private newtype TIRBlock =
  MkIRBlock(Instruction firstInstr) {
    startsBasicBlock(firstInstr)
  }

cached private predicate isEntryBlock(IRBlock block) {
  block.getFirstInstruction() instanceof EnterFunctionInstruction
}

cached private predicate blockSuccessor(IRBlock pred, IRBlock succ) {
  succ = pred.getASuccessor()
}

private predicate blockImmediatelyDominates(IRBlock dominator, IRBlock block) =
  idominance(isEntryBlock/1, blockSuccessor/2)(_, dominator, block)

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
  
  final cached Instruction getInstruction(int index) {
    index = 0 and result = firstInstr or
    (
      index > 0 and
      not startsBasicBlock(result) and
      exists(Instruction predecessor, GotoEdge edge |
        predecessor = getInstruction(index - 1) and
        result = predecessor.getSuccessor(edge)
      )
    )
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
    result.getFirstInstruction() = getLastInstruction().getASuccessor()
  }

  final IRBlock getAPredecessor() {
    firstInstr = result.getLastInstruction().getASuccessor()
  }

  final IRBlock getSuccessor(EdgeKind kind) {
    result.getFirstInstruction() = getLastInstruction().getSuccessor(kind)
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
