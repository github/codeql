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

from MethodAccess m
where
  m.getMethod().hasName("next") and
  m.getMethod().getNumberOfParameters() = 0 and
  (
    not m.hasQualifier() or
    m.getQualifier() instanceof ThisAccess
  ) and
  exists(Interface i, Method hasNext |
    i.getSourceDeclaration().hasQualifiedName("java.util", "Iterator") and
    m.getEnclosingCallable() = hasNext and
    hasNext.getDeclaringType().getSourceDeclaration().getASupertype*() = i and
    hasNext.hasName("hasNext")
  )
select m, "next() called from within an Iterator method."
