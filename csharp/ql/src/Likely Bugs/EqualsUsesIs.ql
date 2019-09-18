/**
 * @name Equals should not apply "is"
 * @description Implementations of 'Equals' should not use "is" to test the type of the argument, but rather call GetType(). This guards against the possibility that the argument type will be subclassed. Otherwise, it is likely that the Equals method will not be symmetric, violating its contract.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cs/equals-uses-is
 * @tags reliability
 *       maintainability
 */

import csharp
import semmle.code.csharp.frameworks.System

from EqualsMethod m, IsExpr e, Class isType
where
  m.fromSource() and
  e.getEnclosingCallable() = m and
  e.getExpr().(VariableAccess).getTarget() = m.getParameter(0) and
  isType = e.getPattern().(TypePatternExpr).getCheckedType() and
  not isType.isSealed() and
  not exists(MethodCall c |
    c.getEnclosingCallable() = m and
    c.getTarget().getName() = "GetType" and
    c.getQualifier().(VariableAccess).getTarget() = m.getParameter(0)
  )
select e,
  m.getDeclaringType().getName() +
    ".Equals(object) should not use \"is\" on its parameter, as it will not work properly for subclasses of "
    + isType.getName() + "."
