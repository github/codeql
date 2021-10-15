import csharp

from UnaryOperation u
where u.getEnclosingCallable().getDeclaringType().hasName("FoldedLiterals")
select u
