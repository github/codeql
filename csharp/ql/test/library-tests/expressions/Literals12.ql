import csharp

from Literal l
where l.getEnclosingCallable().getDeclaringType().hasName("FoldedLiterals")
select l
