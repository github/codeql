/**
 * @name Recursive call to operator==
 * @description A call to 'operator==' is recursive: often this is due to a failed attempt to perform a reference equality comparison.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id cs/recursive-operator-equals-call
 * @tags reliability
 *       maintainability
 */

import csharp

from Operator o, OperatorCall c
where
  o.hasName("==") and
  c.getEnclosingCallable() = o and
  c.getTarget() = o
select c,
  "This call to 'operator==' is recursive: often this is due to a failed attempt to perform a reference equality comparison."
