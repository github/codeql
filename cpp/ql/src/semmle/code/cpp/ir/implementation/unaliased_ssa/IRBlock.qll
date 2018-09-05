private import internal.IRInternal
import Instruction
import semmle.code.cpp.ir.implementation.EdgeKind
private import Construction::BlockConstruction

class IRBlock extends TIRBlock {
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
