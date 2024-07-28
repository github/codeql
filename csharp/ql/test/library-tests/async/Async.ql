import csharp

from Method m
where m.getDeclaringType().hasFullyQualifiedName("Semmle", "Asynchronous")
select m, m.getAModifier()
