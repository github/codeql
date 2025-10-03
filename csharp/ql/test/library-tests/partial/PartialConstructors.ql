import csharp

from Constructor c
where c.getDeclaringType().fromSource()
select c, c.getBody()
