private import ReachableBlockInternal
private import IR
private import ConstantAnalysis

predicate isInfeasibleInstructionSuccessor(Instruction instr, EdgeKind kind) {
  exists(int conditionValue |
    conditionValue = getConstantValue(instr.(ConditionalBranchInstruction).getCondition()) and
    if conditionValue = 0 then kind instanceof TrueEdge else kind instanceof FalseEdge
  )
}

pragma[noinline]
predicate isInfeasibleEdge(IRBlockBase block, EdgeKind kind) {
  isInfeasibleInstructionSuccessor(block.getLastInstruction(), kind)
}

private IRBlock getAFeasiblePredecessorBlock(IRBlock successor) {
  exists(EdgeKind kind |
    result.getSuccessor(kind) = successor and
    not isInfeasibleEdge(result, kind)
  )
}

private predicate isBlockReachable(IRBlock block) {
  exists(IRFunction f | getAFeasiblePredecessorBlock*(block) = f.getEntryBlock())
}

/**
 * An IR block that is reachable from the entry block of the function, considering only feasible
 * edges.
 */
class ReachableBlock extends IRBlockBase {
  ReachableBlock() { isBlockReachable(this) }

  final ReachableBlock getAFeasiblePredecessor() { result = getAFeasiblePredecessorBlock(this) }

  final ReachableBlock getAFeasibleSuccessor() { this = getAFeasiblePredecessorBlock(result) }
}

/**
 * An instruction that is contained in a reachable block.
 */
class ReachableInstruction extends Instruction {
  ReachableInstruction() { this.getBlock() instanceof ReachableBlock }
}

module Graph {
  predicate isEntryBlock(ReachableBlock block) { exists(IRFunction f | block = f.getEntryBlock()) }

  predicate blockSuccessor(ReachableBlock pred, ReachableBlock succ) {
    succ = pred.getAFeasibleSuccessor()
  }
}
