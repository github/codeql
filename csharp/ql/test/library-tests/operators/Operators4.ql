/**
 * @name Test for operators
 */

import csharp

from ExplicitConversionOperator o
where
  o.getTargetType() = o.getDeclaringType() and
  o.getSourceType() instanceof ByteType
select o
