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
  MemsetCallInstruction() {
    this.getValue() = "0" and
    this.getResultType().getUnspecifiedType() instanceof PointerType
  }
}

predicate explicitNullTestOfInstruction(Instruction checked, Instruction bool) {
  bool = any(CompareInstruction cmp |
      exists(NullInstruction null |
        cmp.getLeft() = null and cmp.getRight() = checked
        or
        cmp.getLeft() = checked and cmp.getRight() = null
      |
        cmp instanceof CompareEQInstruction
        or
        cmp instanceof CompareNEInstruction
      )
    )
  or
  bool = any(ConvertInstruction convert |
      checked = convert.getUnary() and
      convert.getResultType() instanceof BoolType and
      checked.getResultType() instanceof PointerType
    )
}

pragma[noinline]
predicate candidateResult(LoadInstruction checked, ValueNumber value, IRBlock dominator) {
  explicitNullTestOfInstruction(checked, _) and
  not checked.getAST().isInMacroExpansion() and
  value.getAnInstruction() = checked and
  dominator.dominates(checked.getBlock())
}

from LoadInstruction checked, LoadInstruction deref, ValueNumber sourceValue, IRBlock dominator
where
  candidateResult(checked, sourceValue, dominator) and
  sourceValue.getAnInstruction() = deref.getSourceAddress() and
  // This also holds if the blocks are equal, meaning that the check could come
  // before the deref. That's still not okay because when they're in the same
  // basic block then the deref is unavoidable even if the check concluded that
  // the pointer was null. To follow this idea to its full generality, we
  // should also give an alert when `check` post-dominates `deref`.
  deref.getBlock() = dominator
select checked, "This null check is redundant because the value is $@ in any case", deref,
  "dereferenced here"
 select fc, "Call to " + fc.getTarget().getName() + " may be deleted by the compiler."
