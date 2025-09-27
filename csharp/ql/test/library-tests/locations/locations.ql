import csharp

from Type t, Method m, SourceLocation l
where t = m.getDeclaringType() and l = m.getLocation() and not l instanceof EmptyLocation
select t, m, l
