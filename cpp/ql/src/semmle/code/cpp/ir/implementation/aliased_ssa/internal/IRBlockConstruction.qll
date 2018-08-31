import SSAConstructionInternal
private import SSAConstruction as Construction
private import NewIR

import Cached
private cached module Cached {
  cached newtype TIRBlock = MkIRBlock(OldIR::IRBlock oldBlock)

  private OldIR::IRBlock getOldBlock(TIRBlock block) {
    block = MkIRBlock(result)
  }

  cached Instruction getInstruction(TIRBlock block, int index) {
    Construction::getOldInstruction(result) =
      getOldBlock(block).getInstruction(index)
  }

  cached int getInstructionCount(TIRBlock block) {
    result = getOldBlock(block).getInstructionCount()
  }

  cached predicate blockSuccessor(TIRBlock pred, TIRBlock succ, EdgeKind kind) {
    succ = MkIRBlock(getOldBlock(pred).getSuccessor(kind))
  }

  cached predicate blockSuccessor(TIRBlock pred, TIRBlock succ) {
    blockSuccessor(pred, succ, _)
  }

  cached predicate blockImmediatelyDominates(TIRBlock dominator, TIRBlock block) {
    getOldBlock(dominator).immediatelyDominates(getOldBlock(block))
  }

  cached Instruction getFirstInstruction(TIRBlock block) {
    Construction::getOldInstruction(result) =
      getOldBlock(block).getFirstInstruction()
  }
}
