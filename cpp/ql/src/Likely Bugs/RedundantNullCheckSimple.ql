/**
 * @name Redundant null check due to previous dereference
 * @description Checking a pointer for nullness after dereferencing it is
 *              likely to be a sign that either the check can be removed, or
 *              it should be moved before the dereference.
 * @kind problem
 * @problem.severity error
 * @id cpp/redundant-null-check-simple
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-476
 */

/*
 * Note: this query is not assigned a precision yet because we don't want it on
 * LGTM until its performance is well understood. It's also lacking qhelp.
 */

import semmle.code.cpp.ir.IR

class NullInstruction extends ConstantValueInstruction {
  NullInstruction() {
    this.getValue() = "0" and
    this.getResultType().getUnspecifiedType() instanceof PointerType
  }
}

/**
 * An instruction that will never have slicing on its result.
 */
class SingleValuedInstruction extends Instruction {
  SingleValuedInstruction() {
    this.getResultMemoryAccess() instanceof IndirectMemoryAccess
    or
    not this.hasMemoryResult()
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

from LoadInstruction checked, LoadInstruction deref, SingleValuedInstruction sourceValue
where
  explicitNullTestOfInstruction(checked, _) and
  sourceValue = deref.getSourceAddress().(LoadInstruction).getSourceValue() and
  sourceValue = checked.getSourceValue() and
  // This also holds if the blocks are equal, meaning that the check could come
  // before the deref. That's still not okay because when they're in the same
  // basic block then the deref is unavoidable even if the check concluded that
  // the pointer was null. To follow this idea to its full generality, we
  // should also give an alert when `check` post-dominates `deref`.
  deref.getBlock().dominates(checked.getBlock()) and
  not checked.getAST().isInMacroExpansion()
select checked, "This null check is redundant because the value is $@ in any case", deref,
  "dereferenced here"
