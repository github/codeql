/**
 * @name Test for byte type
 * @kind table
 */

import csharp

from Method m
where
  m.getName() = "ByteType" and
  m.getReturnType() instanceof ByteType
select m
