import csharp

from TupleExpr e, int i
where e.fromSource()
select e, e.getType(), i, e.getArgument(i)
