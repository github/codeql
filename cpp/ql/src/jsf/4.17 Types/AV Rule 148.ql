/**
 * @name Use of integer where enum is preferred
 * @description Enumeration types should be used instead of integer types (and constants) to select from a limited series of choices.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/integer-used-for-enum
 * @tags maintainability
 *       readability
 *       language-features
 *       external/jsf
 */

import cpp

// flag switch statements where every non-default case dispatches on an integer constant
from SwitchStmt s
where
  forex(SwitchCase sc | sc = s.getASwitchCase() and not sc instanceof DefaultCase |
    sc.getExpr().(VariableAccess).getTarget().isConst()
  ) and
  // Allow switch on character types
  not s.getExpr().getUnspecifiedType() instanceof CharType
select s,
  "Enumeration types should be used instead of integers to select from a limited series of choices."
