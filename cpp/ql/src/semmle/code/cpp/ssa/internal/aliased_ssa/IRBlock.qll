private import IRInternal
private import Construction::OldIR as OldIR
import Instruction
import semmle.code.cpp.ir.EdgeKind

cached newtype TIRBlock = MkIRBlock(OldIR::IRBlock oldBlock)

class IRBlock extends TIRBlock {
  OldIR::IRBlock oldBlock;

  IRBlock() {
    this = MkIRBlock(oldBlock)
  }

  final string toString() {
    result = oldBlock.toString()
  }

  final Location getLocation() {
    result = oldBlock.getLocation()
  }

  final string getUniqueId() {
    result = oldBlock.getUniqueId()
  }

  final Instruction getInstruction(int index) {
    Construction::getOldInstruction(result) = oldBlock.getInstruction(index)
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
    Construction::getOldInstruction(result) = oldBlock.getFirstInstruction()
  }

  final Instruction getLastInstruction() {
    Construction::getOldInstruction(result) = oldBlock.getLastInstruction()
  }

  final int getInstructionCount() {
    result = oldBlock.getInstructionCount()
  }

  final FunctionIR getFunctionIR() {
    result = getFirstInstruction().getFunctionIR()
  }

  final Function getFunction() {
    result = getFirstInstruction().getFunction()
  }

  final IRBlock getASuccessor() {
    result = MkIRBlock(oldBlock.getASuccessor())
  }

  final IRBlock getAPredecessor() {
    result.getASuccessor() = this
  }

  final IRBlock getSuccessor(EdgeKind kind) {
    result = MkIRBlock(oldBlock.getSuccessor(kind))
  }

  final predicate immediatelyDominates(IRBlock block) {
    oldBlock.immediatelyDominates(block.getOldBlock())
  }

  final predicate strictlyDominates(IRBlock block) {
    // This is recomputed from scratch rather than reusing the corresponding
    // predicate of `getOldBlock` because `getOldBlock.strictlyDominates/1` may
    // at run time be a compactly stored transitive closure that we don't want
    // to risk materializing in order to join with `MkIRBlock`.
    immediatelyDominates+(block)
  }

  final predicate dominates(IRBlock block) {
    strictlyDominates(block) or this = block
  }

  pragma[noinline]
  final IRBlock dominanceFrontier() {
    dominates(result.getAPredecessor()) and
    not strictlyDominates(result)
  }

  private OldIR::IRBlock getOldBlock() {
    result = oldBlock
  }
}
