private import ReachableBlockInternal
private import semmle.code.cpp.ir.internal.IntegerConstant
private import IR
private import ConstantAnalysis

predicate isInfeasibleInstructionSuccessor(Instruction instr, EdgeKind kind) {
  exists(int conditionValue |
    conditionValue = getValue(getConstantValue(instr.(ConditionalBranchInstruction).getCondition())) and
    if conditionValue = 0 then
      kind instanceof TrueEdge
    else
      kind instanceof FalseEdge
  )
}

predicate isInfeasibleEdge(IRBlock block, EdgeKind kind) {
  isInfeasibleInstructionSuccessor(block.getLastInstruction(), kind)
}

IRBlock getAFeasiblePredecessorBlock(IRBlock successor) {
  exists(EdgeKind kind |
    result.getSuccessor(kind) = successor and
    not isInfeasibleEdge(result, kind)
  )
}

predicate isBlockReachable(IRBlock block) {
  exists(FunctionIR f |
    getAFeasiblePredecessorBlock*(block) = f.getEntryBlock()
  )
}

predicate isInstructionReachable(Instruction instr) {
  isBlockReachable(instr.getBlock())
}

class ReachableBlock extends IRBlock {
  ReachableBlock() {
    isBlockReachable(this)
  }

  final ReachableBlock getAFeasiblePredecessor() {
    result = getAFeasiblePredecessorBlock(this)
  }

  final ReachableBlock getAFeasibleSuccessor() {
    this = getAFeasiblePredecessorBlock(result)
  }
}

class ReachableInstruction extends Instruction {
  ReachableInstruction() {
    this.getBlock() instanceof ReachableBlock
  }
}

module Graph {
  predicate isEntryBlock(ReachableBlock block) {
    exists(FunctionIR f |
      block = f.getEntryBlock()
    )
  }

  predicate blockSuccessor(ReachableBlock pred, ReachableBlock succ) {
    succ = pred.getAFeasibleSuccessor()
  }
}
