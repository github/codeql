import csharp

from Expr e
where e.getFile().getStem() = "NativeInt"
select e, e.getType().toString()
