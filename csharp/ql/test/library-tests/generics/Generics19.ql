/**
 * @name Test that locations are populated for the type parameters of generic methods
 */

import csharp

from UnboundGenericMethod m, TypeParameter tp, int hasLoc
where
  m.hasName("fs") and
  tp = m.getATypeParameter() and
  if exists(tp.getLocation()) then hasLoc = 1 else hasLoc = 0
select m, tp, hasLoc
