import semmle.code.cpp.ir.implementation.raw.Instruction
import cpp
import semmle.code.cpp.ir.implementation.EdgeKind

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

private predicate isEntryBlock(TIRBlock block) {
  block = MkIRBlock(any(EnterFunctionInstruction enter))
}

import Cached
private cached module Cached {
  cached newtype TIRBlock =
    MkIRBlock(Instruction firstInstr) {
      startsBasicBlock(firstInstr)
    }

  cached Instruction getInstruction(TIRBlock block, int index) {
    index = 0 and block = MkIRBlock(result) or
    (
      index > 0 and
      not startsBasicBlock(result) and
      exists(Instruction predecessor, GotoEdge edge |
        predecessor = getInstruction(block, index - 1) and
        result = predecessor.getSuccessor(edge)
      )
    )
  }

  cached int getInstructionCount(TIRBlock block) {
    result = strictcount(getInstruction(block, _))
  }

  cached predicate blockSuccessor(TIRBlock pred, TIRBlock succ, EdgeKind kind) {
    exists(Instruction predLast, Instruction succFirst |
      predLast = getInstruction(pred, getInstructionCount(pred) - 1) and
      succFirst = predLast.getSuccessor(kind) and
      succ = MkIRBlock(succFirst)
    )
  }

  cached predicate blockSuccessor(TIRBlock pred, TIRBlock succ) {
    blockSuccessor(pred, succ, _)
  }

  cached predicate blockImmediatelyDominates(TIRBlock dominator, TIRBlock block) =
    idominance(isEntryBlock/1, blockSuccessor/2)(_, dominator, block)
}

Instruction getFirstInstruction(TIRBlock block) {
  block = MkIRBlock(result)
}
