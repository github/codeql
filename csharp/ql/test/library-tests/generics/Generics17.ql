/**
 * @name Test for generics
 */

import csharp

from Class c, TypeParameter p, UnboundGenericMethod m, TypeParameter q, UnboundGenericMethod n
where
  c.hasName("Subtle") and
  m = c.getAMethod() and
  m.getATypeParameter() = p and
  n = c.getAMethod() and
  n.getATypeParameter() = q and
  m != n and
  p != q
select c, m, m.getNumberOfParameters(), p, n, q
