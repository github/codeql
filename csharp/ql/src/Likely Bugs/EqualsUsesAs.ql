/**
 * @name Equals should not apply "as"
 * @description Implementations of 'Equals' should not use "as" to test the type of the argument, but rather call GetType(). This guards against the possibility that the argument type will be subclassed. Otherwise, it is likely that the Equals method will not be symmetric, violating its contract.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cs/equals-uses-as
 * @tags reliability
 *       maintainability
 */

import csharp
import semmle.code.csharp.frameworks.System

from EqualsMethod m, AsExpr e, Class asType
where
  m.fromSource() and
  e.getEnclosingCallable() = m and
  e.getExpr().(VariableAccess).getTarget() = m.getParameter(0) and
  asType = e.getTargetType() and
  not asType.isSealed() and
  not exists(MethodCall c, Variable v |
    c.getEnclosingCallable() = m and
    c.getTarget().getName() = "GetType" and
    v = c.getQualifier().(VariableAccess).getTarget()
  |
    v = m.getParameter(0) or
    v.getAnAssignedValue() = e
  )
select e,
  m.getDeclaringType().getName() +
    ".Equals(object) should not use \"as\" on its parameter, as it will not work properly for subclasses of "
    + asType.getName() + "."
