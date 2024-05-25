/**
 * @name Start of thread in constructor
 * @description Starting a thread within a constructor may cause the thread to start before
 *              any subclass constructor has completed its initialization, causing unexpected
 *              results.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/thread-start-in-constructor
 * @tags reliability
 *       correctness
 *       concurrency
 */

import java

/**
 * Holds if this type is either `final` or
 * `private` and without subtypes.
 */
private predicate cannotBeExtended(RefType t) {
  t.isFinal()
  or
  // If the class is private, all possible subclasses are known.
  t.isPrivate() and
  not exists(RefType sub | sub != t | sub.getAnAncestor() = t)
}

from MethodCall m, Constructor c, Class clazz
where
  m.getMethod().getDeclaringType().hasQualifiedName("java.lang", "Thread") and
  m.getMethod().getName() = "start" and
  m.getEnclosingCallable() = c and
  c.getDeclaringType() = clazz and
  not cannotBeExtended(clazz)
select m, "Class $@ starts a thread in its constructor.", clazz, clazz.getName()
