/**
 * @name Call to `memset` may be deleted
 * @description Calling `memset` or `bzero` on a buffer in order to clear its contents may get optimized away
 *              by the compiler if said buffer is not subsequently used.  This is not desirable
 *              behavior if the buffer contains sensitive data that could be exploited by an attacker.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cpp/memset-may-be-deleted
 * @tags security
 *       external/cwe/cwe-14
 */

import cpp
import semmle.code.cpp.ir.IR
import semmle.code.cpp.ir.ValueNumbering
import semmle.code.cpp.models.implementations.Memset

class MemsetCallInstruction extends CallInstruction {
  MemsetCallInstruction() { this.getStaticCallTarget() instanceof MemsetFunction }
}

private Instruction insnSuccessor(Instruction i) {
  exists(GotoEdge edge | result = i.getSuccessor(edge))
}

private predicate insnDominates(Instruction i1, Instruction i2) {
  i1.getBlock().dominates(i2.getBlock())
  or
  i1.getBlock() = i2.getBlock() and insnSuccessor+(i1) = i2
}

Instruction getAUseInstruction(Instruction insn) {
  result=	insn.getAUse().getUse()
}

//insnDominates(memset, deref) and
//vn.getAnInstruction() = memset.getAnArgument() and
//vn.getAnInstruction() = deref.getSourceAddress()
from MemsetCallInstruction memset, SizedBufferMustWriteSideEffectInstruction sei
where sei.getPrimaryInstruction() = memset // and forall(Instruction use | use = getAUseInstruction+(sei) | use instanceof ChiInstruction)
select memset,
  "Call to " + memset.getStaticCallTarget().getName() + " may be deleted by the compiler."
