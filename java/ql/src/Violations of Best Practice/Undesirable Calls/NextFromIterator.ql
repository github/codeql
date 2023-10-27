/**
 * @name Next in hasNext implementation
 * @description Iterator implementations whose 'hasNext' method calls 'next' are most likely
 *              incorrect.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/iterator-hasnext-calls-next
 * @tags reliability
 *       correctness
 */

import java

from MethodCall m
where
  m.getMethod().hasName("next") and
  m.getMethod().getNumberOfParameters() = 0 and
  m.isOwnMethodCall() and
  exists(Interface i, Method hasNext |
    i.getSourceDeclaration().hasQualifiedName("java.util", "Iterator") and
    m.getEnclosingCallable() = hasNext and
    hasNext.getDeclaringType().getSourceDeclaration().getAnAncestor() = i and
    hasNext.hasName("hasNext")
  )
select m, "This calls 'next()' from within an Iterator method."
