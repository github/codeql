/**
 * @name Returned pointer not checked
 * @description Dereferencing an untested value from a function that can return null may lead to undefined behavior.
 * @kind problem
 * @id cpp/missing-null-test
 * @problem.severity recommendation
 * @tags reliability
 *       security
 *       external/cwe/cwe-476
 */

import cpp

from VariableAccess access
where
  maybeNull(access) and
  dereferenced(access)
select access, "Value may be null; it should be checked before dereferencing."
