import csharp

from InlineArrayType t
where t.fromSource()
select t, t.getElementType().toString(), t.getDimension(), t.getLength()
