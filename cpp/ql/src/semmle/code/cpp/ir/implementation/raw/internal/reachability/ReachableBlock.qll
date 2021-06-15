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

private predicate getAFeasiblePredecessorBlock(IRBlock successor, IRBlock block) {
  exists(EdgeKind kind |
    block.getSuccessor(kind) = successor and
    not isInfeasibleEdge(block, kind)
  )
}

private predicate isBlockReachable(IRBlock block) {
  exists(IRFunction f | getAFeasiblePredecessorBlock*(block, f.getEntryBlock()))
}

/**
 * An IR block that is reachable from the entry block of the function, considering only feasible
 * edges.
 */
class ReachableBlock extends IRBlockBase {
  ReachableBlock() { isBlockReachable(this) }

  pragma[inline]
  final ReachableBlock getAFeasiblePredecessor() { getAFeasiblePredecessorBlock(this, result) }

  pragma[inline]
  final ReachableBlock getAFeasibleSuccessor() { getAFeasiblePredecessorBlock(result, this) }
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
