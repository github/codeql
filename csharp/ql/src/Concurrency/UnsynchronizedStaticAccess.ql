/**
 * @name Unsynchronized access to static collection member in non-static context
 * @description If an unsynchronized access to a static collection member occurs
 *              during an addition or resizing operation, an infinite loop can occur.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id cs/unsynchronized-static-access
 * @tags quality
 *       reliability
 *       concurrency
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
    any(LockingCall call).getControlFlowNode().getASuccessor+() = access.getControlFlowNode()
  )
}

predicate firstLockingCallInBlock(BasicBlock b, int i) {
  i = min(int j | b.getNode(j).asExpr() instanceof LockingCall)
}

BasicBlock unlockedReachable(Callable a) {
  result = a.getEntryPoint().getBasicBlock()
  or
  exists(BasicBlock mid | mid = unlockedReachable(a) |
    not firstLockingCallInBlock(mid, _) and
    result = mid.getASuccessor()
  )
}

predicate unlockedCalls(Callable a, Callable b) {
  exists(Call call, BasicBlock callBlock, int j |
    call.getControlFlowNode() = callBlock.getNode(j) and
    callBlock = unlockedReachable(a) and
    (
      exists(int i | j <= i and firstLockingCallInBlock(callBlock, i))
      or
      not firstLockingCallInBlock(callBlock, _)
    ) and
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
