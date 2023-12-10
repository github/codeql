/**
 * @name Poor logging: use of system output stream
 * @description Finds uses of system output streams instead of proper logging
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id cs/console-output
 * @tags maintainability
 */

import csharp
import semmle.code.csharp.commons.Util

predicate isConsoleOutRedefinedSomewhere() {
  exists(MethodCall mc |
    mc.getTarget().hasName("SetOut") and
    mc.getTarget().getDeclaringType().hasFullyQualifiedName("System", "Console")
  )
}

predicate isConsoleErrorRedefinedSomewhere() {
  exists(MethodCall mc |
    mc.getTarget().hasName("SetError") and
    mc.getTarget().getDeclaringType().hasFullyQualifiedName("System", "Console")
  )
}

predicate isCallToConsoleWrite(MethodCall mc) {
  mc.getTarget().getName().matches("Write%") and
  mc.getTarget().getDeclaringType().hasFullyQualifiedName("System", "Console")
}

predicate isAccessToConsoleOut(PropertyAccess pa) {
  pa.getTarget().hasName("Out") and
  pa.getTarget().getDeclaringType().hasFullyQualifiedName("System", "Console")
}

predicate isAccessToConsoleError(PropertyAccess pa) {
  pa.getTarget().hasName("Error") and
  pa.getTarget().getDeclaringType().hasFullyQualifiedName("System", "Console")
}

from Expr e
where
  (
    isCallToConsoleWrite(e) and not isConsoleOutRedefinedSomewhere()
    or
    isAccessToConsoleOut(e) and not isConsoleOutRedefinedSomewhere()
    or
    isAccessToConsoleError(e) and not isConsoleErrorRedefinedSomewhere()
  ) and
  not e.getEnclosingCallable() instanceof MainMethod
select e, "Poor logging: use of system output stream."
