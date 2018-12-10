private import ReachableBlockInternal
private import semmle.code.cpp.ir.internal.IntegerConstant
private import IR
private import ConstantAnalysis

predicate isInfeasibleEdge(IRBlock block, EdgeKind kind) {
  exists(ConditionalBranchInstruction instr, int conditionValue |
    instr = block.getLastInstruction() and
    conditionValue = getValue(getConstantValue(instr.getCondition())) and
    if conditionValue = 0 then
      kind instanceof TrueEdge
    else
      kind instanceof FalseEdge
  )
}

IRBlock getAFeasiblePredecessor(IRBlock successor) {
  exists(EdgeKind kind |
    result.getSuccessor(kind) = successor and
    not isInfeasibleEdge(result, kind)
  )
}

predicate isBlockReachable(IRBlock block) {
  getAFeasiblePredecessor*(block) = block.getFunctionIR().getEntryBlock()
}

predicate isInstructionReachable(Instruction instr) {
  isBlockReachable(instr.getBlock())
}

class ReachableBlock extends IRBlock {
  ReachableBlock() {
    isBlockReachable(this)
  }
}

class ReachableInstruction extends Instruction {
  ReachableInstruction() {
    this.getBlock() instanceof ReachableBlock
  }
}

module Graph {
  predicate isEntryBlock(ReachableBlock block) {
    block = block.getFunctionIR().getEntryBlock()
  }

  predicate blockSuccessor(ReachableBlock pred, ReachableBlock succ) {
    succ = pred.getASuccessor()
  }
}
