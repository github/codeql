/**
 * @name Unchecked cast in Equals method
 * @description The object passed as a parameter to 'Equals' is used in a cast without first checking its type, which can cause an unwanted 'InvalidCastException'.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cs/unchecked-cast-in-equals
 * @tags reliability
 *       maintainability
 */

import csharp
import semmle.code.csharp.frameworks.System

predicate nodeBeforeParameterAccess(ControlFlow::Node node) {
  exists(EqualsMethod equals | equals.getBody() = node.getElement())
  or
  exists(EqualsMethod equals, Parameter param, ControlFlow::Node mid |
    equals.getParameter(0) = param and
    equals.getAChild*() = mid.getElement() and
    nodeBeforeParameterAccess(mid) and
    not param.getAnAccess() = mid.getElement() and
    mid.getASuccessor() = node
  )
}

from ParameterAccess access, CastExpr cast
where
  access = cast.getAChild() and
  access.getTarget().getDeclaringElement() = access.getEnclosingCallable() and
  nodeBeforeParameterAccess(access.getAControlFlowNode())
select cast, "Missing type-check before casting parameter to 'Equals'."
