/**
 * @name Inconsistent synchronization for writeObject()
 * @description Classes with a synchronized 'writeObject' method but no other
 *              synchronized methods usually lack a sufficient level of synchronization.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/inconsistent-sync-writeobject
 * @tags reliability
 *       correctness
 *       concurrency
 *       language-features
 *       external/cwe/cwe-662
 */

import java

from Method m
where
  m.getDeclaringType().getASupertype*() instanceof TypeSerializable and
  m.hasName("writeObject") and
  m.getNumberOfParameters() = 1 and
  m.getAParamType().(Class).hasQualifiedName("java.io", "ObjectOutputStream") and
  m.isSynchronized() and
  not exists(Method s |
    m.getDeclaringType().inherits(s) and
    s.isSynchronized() and
    s != m
  )
select m, "Class's writeObject() method is synchronized but nothing else is."
