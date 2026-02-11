import csharp

from MethodCall c
where c.isImplicit()
select c, c.getTarget().getDeclaringType().toString()
