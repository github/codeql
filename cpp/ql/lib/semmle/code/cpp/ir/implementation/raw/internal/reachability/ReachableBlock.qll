private import ReachableBlockInternal
private import IR
private import ConstantAnalysis

predicate isInfeasibleInstructionSuccessor(Instruction instr, EdgeKind kind) {
  exists(int conditionValue |
    conditionValue = getConstantValue(instr.(ConditionalBranchInstruction).getCondition()) and
    if conditionValue = 0 then kind instanceof TrueEdge else kind instanceof FalseEdge
  )
  or
  instr.getSuccessor(kind) instanceof UnreachedInstruction and
  kind instanceof GotoEdge
  or
  isCallToNonExit(instr)
}

/**
 * Holds if all calls to `f` never return
 */
private predicate isNonExitFunction(IRFunction f) {
  // If all flows to the exit block are pass through an unreachable then f never returns.
  any(UnreachedInstruction instr).getBlock().postDominates(f.getEntryBlock())
  or
  // If there is no flow to the exit block then f never returns.
  not exists(IRBlock entry, IRBlock exit |
    exit = f.getExitFunctionInstruction().getBlock() and
    entry = f.getEntryBlock() and
    exit = entry.getASuccessor*()
  )
  or
  // If all flows to the exit block are pass through a call that never returns then f never returns.
  exists(CallInstruction ci |
    ci.getBlock().postDominates(f.getEntryBlock()) and
    isCallToNonExit(ci)
  )
}

/**
 * Holds if the call `ci` never returns.
 */
private predicate isCallToNonExit(CallInstruction ci) {
  exists(IRFunction callee, Language::Function staticTarget |
    staticTarget = ci.getStaticCallTarget() and
    staticTarget = callee.getFunction() and
    // We can't tell if the call is virtual or not
    // if the callee is virtual. So assume that the call is virtual.  
    not staticTarget.isVirtual() and
    isNonExitFunction(callee) 
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
  ReachableInstruction() {
    this.getBlock() instanceof ReachableBlock and not this instanceof UnreachedInstruction
  }
}

module Graph {
  predicate isEntryBlock(ReachableBlock block) { exists(IRFunction f | block = f.getEntryBlock()) }

  predicate blockSuccessor(ReachableBlock pred, ReachableBlock succ) {
    succ = pred.getAFeasibleSuccessor()
  }
}
