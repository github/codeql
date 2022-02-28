import csharp

from Expr e, int m
where expr_argument(e, m) and e.fromSource()
select e, m
