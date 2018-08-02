/**
 * @name Test for null type
 * @kind table
 */
import csharp

from NullLiteral l
where l.getType() instanceof NullType
select l.getType()
