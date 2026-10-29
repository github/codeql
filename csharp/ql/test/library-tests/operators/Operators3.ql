/**
 * @name Test for operators
 */

import csharp

from ImplicitConversionOperator o
where
  o.getSourceType() = o.getDeclaringType() and
  o.getTargetType() instanceof ByteType
select o
