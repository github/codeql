/**
 * @name Unchecked cast in Equals method
 * @description The object passed as a parameter to 'Equals' is used in a cast without first checking its type, which can cause an unwanted 'InvalidCastException'.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cs/unchecked-cast-in-equals
 * @tags quality
 *       reliability
 *       correctness
 */

import csharp
import semmle.code.csharp.frameworks.System

pragma[nomagic]
predicate nodeBeforeParameterAccess(ControlFlowNode node) {
  exists(EqualsMethod equals | equals.getBody().getControlFlowNode() = node)
  or
  exists(EqualsMethod equals, Parameter param, ControlFlowNode mid |
    equals.getParameter(0) = param and
    equals = mid.getEnclosingCallable() and
    nodeBeforeParameterAccess(mid) and
    not param.getAnAccess().getControlFlowNode() = mid and
    mid.getASuccessor() = node
  )
}

from ParameterAccess access, CastExpr cast
where
  access = cast.getAChild() and
  access.getTarget().getDeclaringElement() = access.getEnclosingCallable() and
  nodeBeforeParameterAccess(access.getControlFlowNode())
select cast, "Equals() method does not check argument type."
