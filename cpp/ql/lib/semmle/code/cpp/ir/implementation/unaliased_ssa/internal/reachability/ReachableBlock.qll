private import ReachableBlockInternal
private import IR
private import ConstantAnalysis

predicate isInfeasibleInstructionSuccessor(Instruction instr, EdgeKind kind) {
  not feasibleInstructionSuccessor(instr, kind)
}

private predicate feasibleInstructionSuccessor(Instruction instr, EdgeKind kind) {
  not exists(int conditionValue |
    conditionValue = getConstantValue(instr.(ConditionalBranchInstruction).getCondition()) and
    if conditionValue = 0 then kind instanceof TrueEdge else kind instanceof FalseEdge
  ) and
  not (
    instr.getSuccessor(kind) instanceof UnreachedInstruction and
    kind instanceof GotoEdge
  ) and
  (
    not instr instanceof CallInstruction or
    isReturningCall(instr)
  )
}

/**
 * Holds if calls to `f` may return
 */
private predicate isReturningFunction(IRFunction f) {
  hasBrokenCfg(f)
  or
  exists(IRBlock exitBlock |
    f.getExitFunctionInstruction().getBlock() = exitBlock and
    isBlockReachable(exitBlock) and
    blockReachesExit(exitBlock)
  )
}

predicate noReturnFunction(IRFunction f) {
  not isReturningFunction(f)
}

predicate hasBrokenCfg(IRFunction f) {
  exists(Instruction missingSucc |
    missingSucc.getEnclosingIRFunction() = f and
    not exists(missingSucc.getASuccessor()) and
    not missingSucc instanceof ExitFunctionInstruction and
    // Phi instructions aren't linked into the instruction-level flow graph.
    not missingSucc instanceof PhiInstruction and
    not missingSucc instanceof UnreachedInstruction
  )
}

/**
 * Holds if the call `ci` may return.
 */
private predicate isReturningCall(CallInstruction ci) {
  exists(IRFunction callee, Language::Function staticTarget |
    staticTarget = ci.getStaticCallTarget() and
    staticTarget = callee.getFunction() and
    // We can't tell if the call is virtual or not
    // if the callee is virtual. So assume that the call is virtual.
    (
      staticTarget.isVirtual() or
      isReturningFunction(callee)
    )
  )
  or
  not exists(IRFunction callee, Language::Function staticTarget |
    staticTarget = ci.getStaticCallTarget() and
    staticTarget = callee.getFunction() 
  )  
}

pragma[noinline]
predicate isFeasibleEdge(IRBlockBase block, EdgeKind kind) {
  feasibleInstructionSuccessor(block.getLastInstruction(), kind)
}

private IRBlock getAFeasiblePredecessorBlock(IRBlock successor) {
  exists(EdgeKind kind |
    result.getSuccessor(kind) = successor and
    isFeasibleEdge(result, kind) and
    blockReachesExit(result)
  )
}

private predicate isBlockReachable(IRBlock block) {
  exists(IRFunction f | getAFeasiblePredecessorBlock*(block) = f.getEntryBlock())
}

/**
 * Holds if `block` reaches the last instruction in the function
 */
private predicate blockReachesExit(IRBlock block) {
  not exists(int i, Instruction instr |
    instr = block.getInstruction(i) and
    i != block.getInstructionCount() - 1 and
    not feasibleInstructionSuccessor(instr, _)
  )
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
