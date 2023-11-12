/**
 * @name Ignored error status of call
 * @description Ignoring an exceptional value that is returned by a method may cause subsequent
 *              code to fail.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/ignored-error-status-of-call
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-391
 */

import java

class SpecialMethod extends Method {
  predicate isMethod(string pack, string clss, string name, int numparam) {
    this.hasName(name) and
    this.getNumberOfParameters() = numparam and
    this.getDeclaringType().getAnAncestor().getSourceDeclaration().hasQualifiedName(pack, clss)
  }
}

predicate unboundedQueue(RefType t) {
  exists(string pack, string clss |
    t.getAnAncestor().getSourceDeclaration().hasQualifiedName(pack, clss)
  |
    pack = "java.util" and clss = "ArrayDeque"
    or
    pack = "java.util" and clss = "LinkedList"
    or
    pack = "java.util" and clss = "PriorityQueue"
    or
    pack = "java.util.concurrent" and clss = "ConcurrentLinkedQueue"
    or
    pack = "java.util.concurrent" and clss = "ConcurrentLinkedDeque"
    or
    pack = "java.util.concurrent" and clss = "DelayQueue"
    or
    pack = "java.util.concurrent" and clss = "LinkedTransferQueue"
    or
    pack = "java.util.concurrent" and clss = "PriorityBlockingQueue"
  )
}

from MethodCall ma, SpecialMethod m
where
  ma instanceof ValueDiscardingExpr and
  m = ma.getMethod() and
  (
    m.isMethod("java.util", "Queue", "offer", 1) and not unboundedQueue(m.getDeclaringType())
    or
    m.isMethod("java.util.concurrent", "BlockingQueue", "offer", 3) and
    not unboundedQueue(m.getDeclaringType())
    or
    m.isMethod("java.util.concurrent.locks", "Condition", "await", 2)
    or
    m.isMethod("java.util.concurrent.locks", "Condition", "awaitUntil", 1)
    or
    m.isMethod("java.util.concurrent.locks", "Condition", "awaitNanos", 1)
    or
    m.isMethod("java.io", "File", "createNewFile", 0)
    or
    m.isMethod("java.io", "File", "mkdir", 0)
    or
    m.isMethod("java.io", "File", "renameTo", 1)
    or
    m.isMethod("java.io", "File", "setLastModified", 1)
    or
    m.isMethod("java.io", "File", "setReadOnly", 0)
    or
    m.isMethod("java.io", "File", "setWritable", 1)
    or
    m.isMethod("java.io", "File", "setWritable", 2)
    or
    m.isMethod("java.io", "InputStream", "skip", 1)
    or
    m.isMethod("java.io", "InputStream", "read", 1)
    or
    m.isMethod("java.io", "InputStream", "read", 3)
  )
select ma,
  "Method " + ma.getEnclosingCallable().getName() + " ignores exceptional return value of " +
    ma.getMethod().getDeclaringType().getName() + "." + ma.getMethod().getName() + "."
