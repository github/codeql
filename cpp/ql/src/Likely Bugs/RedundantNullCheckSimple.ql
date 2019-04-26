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

/** Holds if `deref` is a dereference of `sourceValue` in `block`. */
predicate derefAt(LoadInstruction deref, SingleValuedInstruction sourceValue, IRBlock block) {
  sourceValue = deref.getSourceAddress().(LoadInstruction).getSourceValue() and
  block = deref.getBlock()
}

/** Holds if `checked` is where `sourceValue` is checked for nullness. */
predicate checkAt(LoadInstruction checked, SingleValuedInstruction sourceValue) {
  explicitNullTestOfInstruction(checked, _) and
  sourceValue = checked.getSourceValue() and
  not checked.getAST().isInMacroExpansion() and
  // For performance, there's no need to start traversing the graph unless we
  // could possibly reach a deref.
  derefAt(_, sourceValue, _)
}

/**
 * Holds if `block` dominates `checked`, where `checkAt(checked, sourceValue)`
 * holds, and there is no intervening dereference of `sourceValue`.
 */
predicate checkedReaches(LoadInstruction checked, SingleValuedInstruction sourceValue, IRBlock block) {
  checkAt(checked, sourceValue) and
  // We say that the check reaches everything in its own block, which means it
  // also reaches everything that comes before it. That's okay because when
  // they're in the same basic block then the deref is unavoidable even if the
  // check concluded that the pointer was null. To follow this idea to its full
  // generality, we should also give an alert when `check` post-dominates
  // `deref`.
  block = checked.getBlock()
  or
  exists(IRBlock next |
    checkedReaches(checked, sourceValue, next) and
    block.immediatelyDominates(next) and
    // Stop early to avoid reporting redundant results
    not derefAt(_, sourceValue, next)
  )
}

/**
 * Holds if `deref` and `checked` are a dereference and null check of the same
 * value, where `deref` dominates `checked` and there is no intervening
 * dereference.
 */
pragma[noinline]
predicate derefBeforeChecked(LoadInstruction deref, LoadInstruction checked) {
  exists(SingleValuedInstruction sourceValue, IRBlock derefBlock |
    derefAt(deref, sourceValue, derefBlock) and
    checkedReaches(checked, sourceValue, derefBlock)
  )
}

from LoadInstruction deref, LoadInstruction checked
where derefBeforeChecked(deref, checked)
select checked, "This null check is redundant because the value is $@ in any case", deref,
  "dereferenced here"
