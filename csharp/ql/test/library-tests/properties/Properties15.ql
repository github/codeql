/**
 * @name Test for properties
 */

import csharp

from Property p
where
  p.hasName("Init") and
  p.getDeclaringType().hasFullyQualifiedName("Properties", "Test") and
  p.isWriteOnly() and
  not p.isAutoImplemented() and
  p.isStatic() and
  p.isPrivate() and
  p.getType() instanceof IntType and
  p.getSetter().getStatementBody().isEmpty()
select p
