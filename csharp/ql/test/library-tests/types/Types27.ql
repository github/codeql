import csharp

from NullLiteral l
where l.getType() instanceof NullType
select l.getType()
