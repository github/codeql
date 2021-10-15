import csharp

from Method m
where m.getDeclaringType().getQualifiedName() = "Semmle.Asynchronous"
select m, m.getAModifier()
