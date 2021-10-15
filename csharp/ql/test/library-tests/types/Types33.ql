/**
 * @name Test for binding pointer types
 * @kind table
 */

import csharp

from Method m, PointerType p1, PointerType p2
where
  m.getName() = "PointerPointerType" and
  m.getReturnType() = p1 and
  p1.getReferentType() = p2 and
  p2.getReferentType() instanceof ByteType
select p1.toString(), p2.toString()
