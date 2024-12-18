/**
 * @name Inconsistent null check of pointer
 * @description A dereferenced pointer is not checked for nullness in this location, but it is checked in other locations. Dereferencing a null pointer leads to undefined results.
 * @kind problem
 * @id cpp/inconsistent-nullness-testing
 * @problem.severity warning
 * @security-severity 7.5
 * @tags reliability
 *       security
 *       external/cwe/cwe-476
 */

import cpp

from StackVariable v, ControlFlowNode def, VariableAccess checked, VariableAccess unchecked
where
  checked = v.getAnAccess() and
  // The check can often be in a macro for handling exception
  not checked.isInMacroExpansion() and
  dereferenced(checked) and
  unchecked = v.getAnAccess() and
  dereferenced(unchecked) and
  definitionUsePair(v, def, checked) and
  definitionUsePair(v, def, unchecked) and
  checkedValid(v, checked) and
  not checkedValid(v, unchecked) and
  not unchecked.getParent+() instanceof SizeofOperator and
  forall(ControlFlowNode other | definitionUsePair(v, other, checked) |
    definitionUsePair(v, other, unchecked)
  )
select unchecked,
  "This dereference is not guarded by a non-null check, whereas other dereferences are guarded."
