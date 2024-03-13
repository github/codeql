/**
 * @name Redundant null check due to previous dereference
 * @description Checking a pointer for nullness after dereferencing it is
 *              likely to be a sign that either the check can be removed, or
 *              it should be moved before the dereference.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id cpp/redundant-null-check-simple
 * @tags reliability
 *       correctness
 *       security
 *       external/cwe/cwe-476
 */

import cpp
import semmle.code.cpp.ir.IR
import semmle.code.cpp.ir.ValueNumbering
import PathGraph

/** An instruction that represents a null pointer. */
class NullInstruction extends ConstantValueInstruction {
  NullInstruction() {
    this.getValue() = "0" and
    this.getResultIRType() instanceof IRAddressType
  }
}

/**
 * Holds if `checked` is an instruction that is checked against a null value,
 * and `bool` is the instruction that represents the result of the comparison
 */
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
      convert.getResultIRType() instanceof IRBooleanType and
      checked.getResultIRType() instanceof IRAddressType
    )
}

pragma[nomagic]
predicate candidateResult(LoadInstruction checked, ValueNumber value, IRBlock dominator) {
  explicitNullTestOfInstruction(checked, _) and
  not checked.getAst().isInMacroExpansion() and
  value.getAnInstruction() = checked and
  dominator.dominates(checked.getBlock())
}

/**
 * This module constructs a pretty edges relation out of the results produced by
 * the `candidateResult` predicate: We create a path using the instruction successor-
 * relation from the dereference to the null check. To avoid generating very long paths,
 * we compact the edges relation so that `edges(i1, i2)` only holds when `i2` is the first
 * instruction that is control-flow reachable from `i1` with the same global value number
 * as `i1`.
 */
module PathGraph {
  /**
   * Holds if `deref` is a load instruction that loads a value
   * from the address `address`. This predicate is restricted to
   * those pairs for which we will end up reporting a result.
   */
  private predicate isSource(Instruction address, LoadInstruction deref) {
    exists(ValueNumber sourceValue |
      candidateResult(_, sourceValue, deref.getBlock()) and
      sourceValue.getAnInstruction() = address and
      deref.getSourceAddress() = address
    )
  }

  /**
   * Holds if `checked` has global value number `vn` and is an instruction that is
   * used in a check against a null value.
   */
  private predicate isSink(LoadInstruction checked, ValueNumber vn) {
    candidateResult(checked, vn, _)
  }

  /** Holds if `i` is control-flow reachable from a relevant `LoadInstruction`. */
  private predicate fwdFlow(Instruction i) {
    isSource(i, _)
    or
    exists(Instruction mid |
      fwdFlow(mid) and
      mid.getASuccessor() = i
    )
  }

  /**
   * Holds if `i` is part of a path from a relevant `LoadInstruction` to a
   * check against a null value that compares a value against an instruction
   * with global value number `vn`.
   */
  private predicate revFlow(Instruction i, ValueNumber vn) {
    fwdFlow(i) and
    (
      isSink(i, vn)
      or
      exists(Instruction mid |
        revFlow(mid, vn) and
        i.getASuccessor() = mid
      )
    )
  }

  /**
   * Gets a first control-flow successor of `i` that has the same
   * global value number as `i`.
   */
  private Instruction getASuccessor(Instruction i) {
    exists(ValueNumber vn |
      vn.getAnInstruction() = i and
      result = getASuccessorWithValueNumber(i, vn)
    )
  }

  /**
   * Gets a first control-flow successor of `i` that has the same
   * global value number as `i`. Furthermore, `i` has global value
   * number `vn`.
   */
  private Instruction getASuccessorWithValueNumber(Instruction i, ValueNumber vn) {
    revFlow(i, vn) and
    result = getASuccessorWithValueNumber0(vn, i.getASuccessor()) and
    vn.getAnInstruction() = i
  }

  pragma[nomagic]
  private Instruction getASuccessorWithValueNumber0(ValueNumber vn, Instruction i) {
    result = getASuccessorIfDifferentValueNumberTC(vn, i) and
    vn.getAnInstruction() = result
  }

  /**
   * Computes the reflexive transitive closure of `getASuccessorIfDifferentValueNumber`.
   */
  private Instruction getASuccessorIfDifferentValueNumberTC(ValueNumber vn, Instruction i) {
    revFlow(i, vn) and
    (
      i = result and
      vn.getAnInstruction() = i
      or
      exists(Instruction mid |
        mid = getASuccessorIfDifferentValueNumber(vn, i) and
        result = getASuccessorIfDifferentValueNumberTC(vn, mid)
      )
    )
  }

  /**
   * Gets an instruction that is a control-flow successor of `i` and which is not assigned
   * the global value number `vn`.
   */
  private Instruction getASuccessorIfDifferentValueNumber(ValueNumber vn, Instruction i) {
    revFlow(i, vn) and
    revFlow(result, vn) and
    not vn.getAnInstruction() = i and
    pragma[only_bind_into](result) = pragma[only_bind_into](i).getASuccessor()
  }

  query predicate nodes(Instruction i, string key, string val) {
    revFlow(i, _) and
    key = "semmle.label" and
    val = i.getAst().toString()
  }

  /**
   * The control-flow successor relation, compacted by stepping
   * over instruction that don't preserve the global value number.
   *
   * There is one exception to the above preservation rule: The
   * initial step from the `LoadInstruction` (that is, the sink)
   * steps to the first control-flow reachable instruction that
   * has the same value number as the load instruction's address
   * operand.
   */
  query predicate edges(Instruction i1, Instruction i2) {
    getASuccessor(i1) = i2
    or
    // We could write `isSource(i2, i1)` here, but that would
    // include a not-very-informative step from `*p` to `p`.
    // So we collapse `*p` -> `p` -> `q` to `*p` -> `q`.
    exists(Instruction mid |
      isSource(mid, i1) and
      getASuccessor(mid) = i2
    )
  }
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
select checked, deref, checked, "This null check is redundant because $@ in any case.", deref,
  "the value is dereferenced"
