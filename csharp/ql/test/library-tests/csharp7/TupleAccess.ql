import csharp

from TupleExpr e, string access
where if e.isConstruction() then access = "construct" else access = "deconstruct"
select e, access
