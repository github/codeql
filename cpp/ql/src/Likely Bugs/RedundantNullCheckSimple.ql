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
 * LGTM until its performance is well understood.
 */

import cpp
import semmle.code.cpp.ir.IR
import semmle.code.cpp.ir.ValueNumbering

class NullInstruction extends ConstantValueInstruction {
  NullInstruction() {
    this.getValue() = "0" and
    this.getResultType().getUnspecifiedType() instanceof PointerType
  }
}

predicate explicitNullTestOfInstruction(Instruction checked, Instruction bool) {
  bool =
    any(CompareInstruction cmp |
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
  bool =
    any(ConvertInstruction convert |
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
  checked.getBlock() = dominator
}

predicate derefInstruction(Instruction checked, Instruction bool) {
  bool =
    any(CopyValueInstruction str |
      checked = str.getSourceValue()
    )
}

predicate isCheckedInstruction(Instruction unchecked, Instruction checked, ValueNumber value) {
  checked =
    any(LoadInstruction li |
      li = value.getAnInstruction()
  ) and
  explicitNullTestOfInstruction(checked, _) and
  checked.getBlock().dominates(unchecked.getBlock())
}

pragma[noinline]
predicate candidateResultDeref(LoadInstruction unchecked, ValueNumber value, IRBlock dominator) {
  value.getAnInstruction() = unchecked and
  derefInstruction(unchecked, _) and
  not isCheckedInstruction(unchecked, _, value) and
  not dominator.dominates(unchecked.getBlock())
}

from LoadInstruction checked, LoadInstruction deref, ValueNumber sourceValue, IRBlock dominator
where
  candidateResult(checked, sourceValue, dominator) and
  candidateResultDeref(deref, sourceValue, dominator)
select checked, "This null check is redundant because the value is $@ in any case", deref,
  "dereferenced here"
