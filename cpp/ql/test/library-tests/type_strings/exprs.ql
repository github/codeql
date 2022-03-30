import cpp

from Expr e
where not (e instanceof CStyleCast and e.getValue().matches("%0"))
select e, e.getType().toString(), e.getType().explain()
