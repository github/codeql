import csharp

from Expr e, Type t
where e.fromSource() and t = e.getType()
select e, t.toStringWithTypes(), t.getAPrimaryQlClass()
