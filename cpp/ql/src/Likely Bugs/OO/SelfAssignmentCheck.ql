/**
 * @name Self assignment check
 * @description Copy assignment operators should guard against self assignment;
 *              otherwise, self assignment is likely to cause memory
 *              corruption.
 * @kind problem
 * @id cpp/self-assignment-check
 * @problem.severity warning
 * @security-severity 7.0
 * @tags reliability
 *       security
 *       external/cwe/cwe-826
 */

import cpp

// find copy assignment operators that deallocate memory but do not check for self assignment
from CopyAssignmentOperator cao
where
  exists(DestructorCall d | d.getEnclosingFunction() = cao) and
  not exists(EqualityOperation eq |
    eq.getEnclosingFunction() = cao and
    eq.getAChild() instanceof ThisExpr and
    eq.getAChild().(AddressOfExpr).getAddressable() = cao.getParameter(0)
  )
select cao, "Copy assignment operator does not check for self assignment."
