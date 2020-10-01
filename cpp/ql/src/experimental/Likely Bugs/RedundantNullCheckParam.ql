/**
 * @name Redundant null check or missing null check of parameter
 * @description Checking a parameter for nullness in one path,
 *              and not in another is likely to be a sign that either
 *              the check can be removed, or added in the other case.
 * @kind problem
 * @id cpp/redundant-null-check-param
 * @problem.severity recommendation
 * @tags reliability
 *       security
 *       external/cwe/cwe-476
 */

import cpp

predicate blockDominates(BlockStmt check, BlockStmt access) {
  check.getLocation().getStartLine() <= access.getLocation().getStartLine() and
  check.getLocation().getEndLine() >= access.getLocation().getEndLine()
}

predicate isCheckedInstruction(VariableAccess unchecked, VariableAccess checked) {
  checked = any(VariableAccess va | va.getTarget() = unchecked.getTarget()) and
  //Simple test if the first access in this code path is dereferenced
  not dereferenced(checked) and
  blockDominates(checked.getEnclosingBlock(), unchecked.getEnclosingBlock())
}

predicate candidateResultUnchecked(VariableAccess unchecked) {
  not isCheckedInstruction(unchecked, _)
}

predicate candidateResultChecked(VariableAccess check, EqualityOperation eqop) {
  //not dereferenced to check against pointer, not its pointed value
  not dereferenced(check) and
  //assert macros are not taken into account
  not check.isInMacroExpansion() and
  // is part of a comparison against some constant NULL
  eqop.getAnOperand() = check and
  eqop.getAnOperand() instanceof NullValue
}

from VariableAccess unchecked, VariableAccess check, EqualityOperation eqop, Parameter param
where
  // a dereference
  dereferenced(unchecked) and
  // for a function parameter
  unchecked.getTarget() = param and
  // this function parameter is not overwritten
  count(param.getAnAssignment()) = 0 and
  check.getTarget() = param and
  // which is once checked
  candidateResultChecked(check, eqop) and
  // and which has not been checked before in this code path
  candidateResultUnchecked(unchecked)
select check, "This null check is redundant or there is a missing null check before $@ ", unchecked,
  "where dereferencing happens"
