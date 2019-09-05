/**
 * @name Assignment to parameter has no effect
 * @description An assignment to a parameter that is not subsequently read may
 *              indicate a logic error.
 * @kind problem
 * @problem.severity warning
 */

import cpp

from Parameter p, Assignment assign
where
  assign = p.getAnAssignment() and
  not assign.getASuccessor+() = p.getAnAccess() and
  not p.getType() instanceof ReferenceType
select assign, "Assignment of '" + assign.getRValue() + "' to parameter '$@' has no effect.", p,
  p.getName()
