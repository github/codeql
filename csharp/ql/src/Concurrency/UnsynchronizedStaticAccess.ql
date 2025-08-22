/**
 * @name Unsynchronized access to static collection member in non-static context
 * @description If an unsynchronized access to a static collection member occurs
 *              during an addition or resizing operation, an infinite loop can occur.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id cs/unsynchronized-static-access
 * @tags concurrency
 *       external/cwe/cwe-362
 *       external/cwe/cwe-567
 */

import csharp
import DataMembers
import ThreadCreation

predicate correctlySynchronized(CollectionMember c, Expr access) {
  access = c.getAReadOrWrite() and
  (
    c.getType().(ValueOrRefType).getABaseType*().getName().matches("Concurrent%") or
    access.getEnclosingStmt().getParent*() instanceof LockStmt or
    any(LockingCall call).getAControlFlowNode().getASuccessor+() = access.getAControlFlowNode()
  )
}

ControlFlow::Node unlockedReachable(Callable a) {
  result = a.getEntryPoint()
  or
  exists(ControlFlow::Node mid | mid = unlockedReachable(a) |
    not mid.getAstNode() instanceof LockingCall and
    result = mid.getASuccessor()
  )
}

predicate unlockedCalls(Callable a, Callable b) {
  exists(Call call |
    call.getAControlFlowNode() = unlockedReachable(a) and
    call.getARuntimeTarget() = b and
    not call.getParent*() instanceof LockStmt
  )
}

predicate writtenStaticDictionary(CollectionMember c) {
  c.getType().(ValueOrRefType).getABaseType*().hasName("IDictionary") and
  c.isStatic() and
  exists(Expr write | write = c.getAWrite() |
    not write.getEnclosingCallable() instanceof StaticConstructor
  )
}

predicate nonStaticCallable(Callable c) { not c.(Modifiable).isStatic() }

from CollectionMember c, Expr a, ConcurrentEntryPoint e, Callable enclosing
where
  a = c.getAReadOrWrite() and
  enclosing = a.getEnclosingCallable() and
  nonStaticCallable(enclosing) and
  not correctlySynchronized(c, a) and
  unlockedCalls*(e, enclosing) and
  writtenStaticDictionary(c)
select a, "Unsynchronized access to $@ in non-static context from $@.", c, c.getName(), e,
  e.getName()
