import csharp

from Method m
where m.getDeclaringType().hasQualifiedName("Semmle", "Asynchronous")
select m, m.getAModifier()
