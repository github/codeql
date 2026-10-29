import javascript

from Expr expr
where expr.isUnreachable()
select expr, "is unreachable"
