/**
 * @name Equals or hashCode on arrays
 * @description The 'equals' and 'hashCode' methods on arrays only consider object identity, not
 *              array contents, which is unlikely to be what is intended.
 * @kind problem
 * @problem.severity error
 * @precision very-high
 * @id java/equals-on-arrays
 * @tags quality
 *       reliability
 *       correctness
 */

import java

from MethodCall ma, Array recvtype, Method m
where
  m = ma.getMethod() and
  (
    recvtype = ma.getQualifier().getType() and
    (
      m instanceof HashCodeMethod
      or
      m instanceof EqualsMethod and
      haveIntersection(recvtype, ma.getArgument(0).getType().(Array))
    )
    or
    m.hasQualifiedName("java.util", "Objects", "equals") and
    recvtype = ma.getArgument(0).getType() and
    haveIntersection(recvtype, ma.getArgument(1).getType().(Array))
  )
select ma,
  "The " + m.getName() +
    " method on arrays only considers object identity and ignores array contents."
