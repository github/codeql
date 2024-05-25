/**
 * @name Equals or hashCode on arrays
 * @description The 'equals' and 'hashCode' methods on arrays only consider object identity, not
 *              array contents, which is unlikely to be what is intended.
 * @kind problem
 * @problem.severity error
 * @precision very-high
 * @id java/equals-on-arrays
 * @tags reliability
 *       correctness
 */

import java

from MethodCall ma, Array recvtype, Method m
where
  recvtype = ma.getQualifier().getType() and
  m = ma.getMethod() and
  (
    m instanceof HashCodeMethod
    or
    m instanceof EqualsMethod and
    haveIntersection(recvtype, ma.getArgument(0).getType().(Array))
  )
select ma,
  "The " + m.getName() +
    " method on arrays only considers object identity and ignores array contents."
