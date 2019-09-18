import csharp

from TupleExpr e, string access
where if e.isReadAccess() then access = "read" else access = "write"
select e, access
