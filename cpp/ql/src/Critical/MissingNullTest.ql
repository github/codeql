/**
 * @name Returned pointer not checked
 * @description A value returned from a function that may return null is not tested to determine whether or not it is null. Dereferencing NULL pointers lead to undefined behavior.
 * @kind problem
 * @id cpp/missing-null-test
 * @problem.severity recommendation
 * @tags reliability
 *       security
 *       external/cwe/cwe-476
 */
import cpp

from VariableAccess access
where maybeNull(access)
  and dereferenced(access)
select access, "Value may be null; it should be checked before dereferencing."
